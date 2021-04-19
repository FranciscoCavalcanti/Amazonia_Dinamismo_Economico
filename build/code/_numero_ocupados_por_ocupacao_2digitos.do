// gerar variavel de codigo de 2 digitos
cap tostring V4010, replace
cap replace V4010 = "" if V4010 == "."
gen tempvar1 = strlen(V4010) // lenght of the variable
replace V4010 = "0" + V4010 if tempvar1 == 3
replace V4010 = "00" + V4010 if tempvar1 == 2
replace V4010 = "000" + V4010 if tempvar1 == 1
drop tempvar*
gen cod_codagr = substr(V4010,1,2)

merge n:1  cod_codagr using "$output_dir\cod_cod2dig.dta"
*drop _merge

* pequenos ajustes na definicao das atividades economicas
replace titulo = "Pecuária" if V4010 == "01201"
replace titulo = "Pecuária" if V4010 == "01202"
replace titulo = "Pecuária" if V4010 == "01203"


**************************************************
**	 Calcular numero de ocupados por tipo de ocupação	**
**************************************************

/////////////////////////////////////////////////////////
//	numero de ocupados por tipo de ocupação
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cod = iten2
label variable n_ocu_cod "Número de ocupados por tipo de ocupação"
cap drop iten*

/////////////////////////////////////////////////////////
//	numero de ocupados formal por tipo de ocupação
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & formal ==1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cod_formal = iten2
label variable n_ocu_cod_formal "Número de ocupados formal por tipo de ocupação"
cap drop iten*

/////////////////////////////////////////////////////////
//	numero de ocupados informal por tipo de ocupação
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & informal ==1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cod_informal = iten2
label variable n_ocu_cod_informal "Número de ocupados informal por tipo de ocupação"
cap drop iten*

/////////////////////////////////////////////////////////
//	numero de ocupação publico por tipo de ocupação
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & publico ==1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cod_publico = iten2
label variable n_ocu_cod_publico "Número de ocupação no setor público por tipo de atividade"
cap drop iten*

/////////////////////////////////////////////////////////
//	numero de ocupação privado por tipo de ocupação
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & privado ==1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cod_privado = iten2
label variable n_ocu_cod_privado "Número de ocupação no setor privado por tipo de ocupação"
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
by Ano Trimestre titulo, sort: egen total_renda_ocupado = total(iten1)
gen renda_media = (total_renda_ocupado/n_ocu_cod)
drop iten*
label variable renda_media "Rendimento médio habitual real dos ocupados (R$)"

* Rendimento medio habitual real dos ocupados formal total
gen iten1 = ocupado * (VD4019 * Habitual) * V1028 if formal ==1 
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
gen renda_formal = (iten2/n_ocu_cod_formal)
drop iten*
label variable renda_formal "Rendimento médio habitual real dos ocupados formal (R$)"

* Rendimento medio habitual real dos ocupados informal total
gen iten1 = ocupado * (VD4019 * Habitual) * V1028 if informal ==1 
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
gen renda_informal = (iten2/n_ocu_cod_informal)
drop iten*
label variable renda_informal "Rendimento médio habitual real dos ocupados informal (R$)"

/////////////////////////////////////////////////////////
//	Massa salarial
/////////////////////////////////////////////////////////

* Rendimento medio habitual real * ocupados total
gen iten1 = ocupado * (VD4019 * Habitual) * V1028
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
gen massa_salarial = iten2
drop iten*
label variable massa_salarial "Massa de rendimentos (R$)"


***********************************************
**	Colapsar ao nível do trimestre e setor	 **
***********************************************

// attach label of variables
local colvar n_* renda_* massa_salarial

foreach v of var `colvar' {
    local l`v' : variable label `v'
}

* colapse
collapse (firstnm) `colvar' , by(Ano Trimestre titulo)

// copy back the label of variables
foreach v of var `colvar' {
    label var `v' "`l`v''"
}