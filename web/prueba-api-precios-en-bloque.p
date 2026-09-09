DEFINE VAR pMensaje AS CHAR.
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR pcReturn AS LONGCHAR.


RUN web/web-library PERSISTENT SET hProc.

RUN web_api_unit_price IN hproc
    ("200594,200593,200592,000752",
     "B,B,B,B",
     "002",
     "20456127917",
     "00038",
     OUTPUT pcReturn,
     OUTPUT pMensaje).
DELETE PROCEDURE hProc.
MESSAGE string(pcreturn) SKIP RETURN-VALUE SKIP 'Error:' pMensaje.
/*
RUN web_api_unit_price_manager IN hproc
    ("20456127917",
     "00038",
     "200594,200593,200592,000752",
     "B,B,B",
     "002",
     OUTPUT pcReturn,
     OUTPUT pMensaje).
DELETE PROCEDURE hProc.
MESSAGE string(pcreturn) SKIP RETURN-VALUE SKIP 'Error:' pMensaje.
*/
