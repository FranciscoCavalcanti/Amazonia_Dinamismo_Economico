// gerar variavel de codigo de 2 digitos
cap tostring V4013, replace
cap replace V4013 = "" if V4013 == "."
gen tempvar1 = strlen(V4013) // lenght of the variable
replace V4013 = "0" + V4013 if tempvar1 == 4
replace V4013 = "00" + V4013 if tempvar1 == 3
replace V4013 = "000" + V4013 if tempvar1 == 2
replace V4013 = "0000" + V4013 if tempvar1 == 1
drop tempvar*
gen cod_cnae2dig = substr(V4013,1,2)

merge n:1  cod_cnae2dig using "$output_dir\cod_cnae2dig.dta"
drop _merge

* pequenos ajustes na definicao das atividades economicas
replace titulo = "Pecuária" if V4013 == "01201"
replace titulo = "Pecuária" if V4013 == "01202"
replace titulo = "Pecuária" if V4013 == "01203"
replace titulo = "Pecuária" if V4013 == "01204"
replace titulo = "Pecuária" if V4013 == "01205"
replace titulo = "Pecuária" if V4013 == "01206"
replace titulo = "Pecuária" if V4013 == "01207"
replace titulo = "Pecuária" if V4013 == "01208"
replace titulo = "Pecuária" if V4013 == "01209"

replace titulo = "Pecuária" if V4013 == "01402"
replace titulo = "Pecuária" if V4013 == "01403"
replace titulo = "Pecuária" if V4013 == "01404"
replace titulo = "Pecuária" if V4013 == "01405"
replace titulo = "Pecuária" if V4013 == "01406"
replace titulo = "Pecuária" if V4013 == "01407"
replace titulo = "Pecuária" if V4013 == "01408"
replace titulo = "Pecuária" if V4013 == "01409"
replace titulo = "Pecuária" if V4013 == "01500"

**************************************************
**	 Calcular numero de ocupação por tipo de atividade	**
**************************************************

/////////////////////////////////////////////////////////
//	numero de ocupação por tipo de atividade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cnae = iten2
label variable n_ocu_cnae "Número de ocupação por tipo de atividade"
cap drop iten*

/////////////////////////////////////////////////////////
//	numero de ocupação formal por tipo de atividade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & formal ==1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cnae_formal = iten2
label variable n_ocu_cnae_formal "Número de ocupação formal por tipo de atividade"
cap drop iten*

/////////////////////////////////////////////////////////
//	numero de ocupação informal por tipo de atividade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & informal ==1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cnae_informal = iten2
label variable n_ocu_cnae_informal "Número de ocupação informal por tipo de atividade"
cap drop iten*

/////////////////////////////////////////////////////////
//	numero de ocupação publico por tipo de atividade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & publico ==1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cnae_publico = iten2
label variable n_ocu_cnae_publico "Número de ocupação no setor público por tipo de atividade"
cap drop iten*

/////////////////////////////////////////////////////////
//	numero de ocupação privado por tipo de atividade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & privado ==1
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
replace iten2 = round(iten2)
gen n_ocu_cnae_privado = iten2
label variable n_ocu_cnae_privado "Número de ocupação no setor privado por tipo de atividade"
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
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
gen renda_media = (iten2/n_ocu_cnae)
drop iten*
label variable renda_media "Rendimento médio habitual real dos ocupados (R$)"

* Rendimento medio habitual real dos ocupados formal total
gen iten1 = ocupado * (VD4019 * Habitual) * V1028 if formal ==1 
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
gen renda_formal = (iten2/n_ocu_cnae_formal)
drop iten*
label variable renda_formal "Rendimento médio habitual real dos ocupados formal (R$)"

* Rendimento medio habitual real dos ocupados informal total
gen iten1 = ocupado * (VD4019 * Habitual) * V1028 if informal ==1 
by Ano Trimestre titulo, sort: egen iten2 = total(iten1)
gen renda_informal = (iten2/n_ocu_cnae_informal)
drop iten*
label variable renda_informal "Rendimento médio habitual real dos ocupados informal (R$)"

/////////////////////////////////////////////////////////
//	Massa salarial
/////////////////////////////////////////////////////////

* Rendimento medio habitual real * ocupação total
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
