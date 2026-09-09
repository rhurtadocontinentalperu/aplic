for each integral.gn-clie:
delete integral.gn-clie.
end.

for each traslado.foxb0006:

find integral.gn-clie where integral.gn-clie.CodCli = "0" + trim (traslado.Foxb0006.Codcli)
no-error.
if not available integral.gn-clie then create integral.gn-clie.

assign.
integral.gn-clie.CodCli = 1.
integral.gn-clie.CodCli = "0" + trim (traslado.Foxb0006.Codcli).
integral.gn-clie.NomCli = traslado.Foxb0006.Avafon traslado.Foxb0006.Razcli.
integral.gn-clie.DirCli = integral.gn-clie.Dircli
end.

