**************************************************
**	 Calcular numero de ocupados por tipo de atividade	**
**************************************************

/////////////////////////////////////////////////////////
//	numero de ocupados por tipo de atividade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1
by Ano Trimestre V4013, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_de_ocupados_por_atividade = iten2
label variable n_de_ocupados_por_atividade "Número de ocupados por tipo de atividade"
cap drop iten*

/////////////////////////////////////////////////////////
//	Rendimentos real
/////////////////////////////////////////////////////////

* Merge na base de dados com o deflator
merge m:1 Ano Trimestre UF using "$input_dir\deflatorPNADC_2012.1-2020.3.dta", update force
drop if _merge==2 
drop _merge

* Rendimento medio habitual real dos ocupados total
gen iten1 = ocupado * (VD4019 * Habitual) * V1028
by Ano Trimestre V4013, sort: egen total_rendimento_ocupado = total(iten1)
gen rendimento_medio_total = (total_rendimento_ocupado/n_de_ocupados_por_atividade)
drop iten*
label variable rendimento_medio_total "Rendimento médio habitual real dos ocupados (R$)"


***********************************************
**	Colapsar ao nível do trimestre e setor	 **
***********************************************

// attach label of variables
local colvar n_* rendimento_*

foreach v of var `colvar' {
    local l`v' : variable label `v'
}

* colapse
collapse (firstnm) `colvar' , by(Ano Trimestre V4013)

// copy back the label of variables
foreach v of var `colvar' {
    label var `v' "`l`v''"
}
