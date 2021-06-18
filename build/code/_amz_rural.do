//////////////////////////////////////////////
//	
//	Calcular o numero de ocupados e rendimento médio por setores na Amazonia
//	
//////////////////////////////////////////////

//////////////////////////////////////////////
//	
//	Calcular o numero de ocupados e rendimento médio por tipo de ocupação na Amazonia
//	(COD de 2 digitos)
//	
//////////////////////////////////////////////

******************************
**	Amazônia Legal Rural	**
******************************

global area_geografica = "Amazônia Legal Rural"

forvalues yr = 2012(1)2020{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	 * sample 1
	* run code
	do "$code_dir\_definicoes_pnadcontinua_trimestral"
	* run code
	do "$code_dir\_numero_ocupados_por_ocupacao_2digitos"
	* save as temporary
	save "$tmp_dir\_temp_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2020{
	* call data
	append using "$tmp_dir\_temp_PNADC`yr'.dta"
}

* save in the output directory
compress
save "$output_dir\_amz_rural_numero_ocupados_por_ocupacao_2digitos.dta", replace

//////////////////////////////////////////////
//	
//	Calcular o numero de ocupados e rendimento médio por atividade na Amazonia
//	(CNAE de 2 digitos)
//	
//////////////////////////////////////////////

******************************
**	Amazônia Legal Rural	**
******************************

global area_geografica = "Amazônia Legal Rural"

forvalues yr = 2012(1)2020{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	 * sample 1
	* run code
	do "$code_dir\_definicoes_pnadcontinua_trimestral"
	* run code
	do "$code_dir\_numero_ocupados_por_atividade_2digitos"
	* save as temporary
	save "$tmp_dir\_temp_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2020{
	* call data
	append using "$tmp_dir\_temp_PNADC`yr'.dta"
}

* save in the output directory
compress
save "$output_dir\_amz_rural_numero_ocupados_por_atividade_2digitos.dta", replace