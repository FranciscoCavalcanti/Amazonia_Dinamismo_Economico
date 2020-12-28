**************************************************
**	 Calcular numero de ocupados por tipo de ocupacao	**
**************************************************

/////////////////////////////////////////////////////////
//	numero de ocupados por tipo de ocupacao
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1
by Ano Trimestre V4013, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_de_ocupados_por_ocupacao = iten2
label variable n_de_ocupados_por_ocupacao "Número de ocupados por tipo de ocupação"
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
