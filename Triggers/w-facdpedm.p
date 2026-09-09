TRIGGER PROCEDURE FOR WRITE OF facdpedm.


IF facdpedm.canped > facdpedm.canate THEN facdpedm.flgest = "P".
ELSE facdpedm.flgest = "C".
