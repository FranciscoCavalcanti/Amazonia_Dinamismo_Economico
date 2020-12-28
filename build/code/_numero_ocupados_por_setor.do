**************************************************
**	 Calcular numero de ocupacoes por setores	**
**************************************************

/////////////////////////////////////////////////////////
//	Numero de ocupacoes por setores
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1
by Ano Trimestre VD4010, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_de_ocupados_por_setor = iten2
label variable n_de_ocupados_por_setor "Número de ocupados por setor econômico"
cap drop iten*


***********************************************
**	Colapsar ao nível do trimestre e setor	 **
***********************************************

// attach label of variables
local colvar n_*

foreach v of var `colvar' {
    local l`v' : variable label `v'
}

* colapse
collapse (firstnm) `colvar' , by(Ano Trimestre VD4010)

// copy back the label of variables
foreach v of var `colvar' {
    label var `v' "`l`v''"
}
