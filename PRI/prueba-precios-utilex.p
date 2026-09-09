DEF NEW SHARED VAR s-codcia AS INTE INIT 001.
DEF NEW SHARED VAR s-coddiv AS CHAR INIT '00027'.
DEF NEW SHARED VAR cl-codcia AS INTE INIT 000.

DEF VAR s-codmon AS INTE INIT 2.
DEF VAR s-tpocmb AS DECI.
DEF VAR s-undvta AS CHAR.
DEF VAR f-prebas AS DECI.
DEF VAR f-prevta AS DECI.
DEF VAR f-dsctos AS DECI.
DEF VAR y-dsctos AS DECI.
DEF VAR z-dsctos AS DECI.
DEF VAR x-tipdto AS CHAR.
DEF VAR f-factor AS DECI.
DEF VAR s-codmat AS CHAR INIT '015803'.
DEF VAR x-canped AS DECI INIT 100.
DEF VAR x-nrodec AS INTE INIT 4.
DEF VAR s-flgsit AS CHAR.
DEF VAR s-codbco AS CHAR.
DEF VAR s-tarjeta AS CHAR.
DEF VAR s-codpro AS CHAR.
DEF VAR s-nrovale AS CHAR.
DEF VAR p-mensaje AS CHAR.

RUN pri/precioventaminoristacontado (
     INPUT  S-CODDIV ,
     INPUT  S-CODMON ,
     INPUT  S-TPOCMB ,
     OUTPUT S-UNDVTA ,
     OUTPUT f-Factor ,
     INPUT S-CODMAT  ,
     INPUT X-CANPED  ,
     INPUT x-NroDec  ,
     INPUT s-FlgSit  ,
     INPUT s-CodBco  ,
     INPUT s-Tarjeta ,
     INPUT s-CodPro  ,
     INPUT s-NroVale ,
     OUTPUT F-PREBAS ,
     OUTPUT F-PREVTA ,
     OUTPUT F-DSCTOS ,
     OUTPUT Y-DSCTOS ,
     OUTPUT Z-DSCTOS ,
     OUTPUT X-TIPDTO ).

MESSAGE 
    's-undvta' s-undvta SKIP
    'f-factor' f-factor SKIP
    'f-prebas' f-prebas  SKIP
    'f-prevta' f-prevta  SKIP
    'f-dsctos' f-dsctos SKIP
    'y-dsctos' y-dsctos SKIP
    'z-dsctos' z-dsctos SKIP
    'x-tipdto' x-tipdto.


RUN pri/precioventaminoristacontado-v2 (
     INPUT  S-CODDIV ,
     INPUT  S-CODMON ,
     INPUT  S-TPOCMB ,
     OUTPUT S-UNDVTA ,
     OUTPUT f-Factor ,
     INPUT S-CODMAT  ,
     INPUT X-CANPED  ,
     INPUT x-NroDec  ,
     OUTPUT F-PREBAS ,
     OUTPUT F-PREVTA ,
     OUTPUT Y-DSCTOS ,
     OUTPUT Z-DSCTOS ,
     OUTPUT X-TIPDTO,
     OUTPUT p-Mensaje ).

MESSAGE 
    's-undvta' s-undvta SKIP
    'f-factor' f-factor SKIP
    'f-prebas' f-prebas  SKIP
    'f-prevta' f-prevta  SKIP
    'y-dsctos' y-dsctos SKIP
    'z-dsctos' z-dsctos SKIP
    'x-tipdto' x-tipdto SKIP
    'p-mensaje' p-mensaje.
