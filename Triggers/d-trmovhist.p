TRIGGER PROCEDURE FOR DELETE OF FacDPedi.

    DEFINE SHARED VAR s-user-id AS CHAR.

    /* Registro nuevo */
    CREATE trmovhist.
    ASSIGN
        trmovhist.canate = FacDPedi.canate
        trmovhist.CanPed = FacDPedi.canped
        trmovhist.CanPick = FacDPedi.CanPick
        trmovhist.CodCia = FacDPedi.CodCia
        trmovhist.CodDoc = FacDPedi.CodDoc
        trmovhist.codmat = FacDPedi.codmat
        trmovhist.fecha = DATETIME(TODAY, MTIME)
        trmovhist.FlgEst = FacDPedi.FlgEst
        trmovhist.Libre_c01 = FacDPedi.Libre_c01
        trmovhist.Libre_c02 = FacDPedi.Libre_c02
        trmovhist.Libre_c03 = FacDPedi.Libre_c03
        trmovhist.Libre_c04 = FacDPedi.Libre_c04
        trmovhist.Libre_c05 = FacDPedi.Libre_c05
        trmovhist.Libre_d01 = FacDPedi.Libre_d01
        trmovhist.Libre_d02 = FacDPedi.Libre_d02
        trmovhist.Libre_f01 = FacDPedi.Libre_f01
        trmovhist.Libre_f02 = FacDPedi.Libre_f02
        trmovhist.NroDoc = FacDPedi.NroPed
        trmovhist.NroItm = FacDPedi.NroItm
        trmovhist.PorDto = FacDPedi.PorDto
        trmovhist.PorDto2 = FacDPedi.PorDto2
        trmovhist.PreBas = FacDPedi.PreBas
        trmovhist.PreUni = FacDPedi.PreUni
        trmovhist.PreVta[1] = FacDPedi.PreVta[1]
        trmovhist.PreVta[2] = FacDPedi.PreVta[2]
        trmovhist.PreVta[3] = FacDPedi.PreVta[3]
        trmovhist.programa = PROGRAM-NAME(1)
        trmovhist.tpotrans = "ELIMINA"
        trmovhist.trnbr = NEXT-VALUE(trMovSeq01)
        trmovhist.usuario = s-user-id.
