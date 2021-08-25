//////////////////////////////////////////////
//	Calcular o numero de ocupados e rendimento médio por tipo de ocupação na Amazonia
//	(COD de 2 digitos)
//////////////////////////////////////////////

capture macro drop sub_amostra_area_geografica sub_amostra_demografia
global sub_amostra_area_geografica = "Roraima"
global sub_amostra_demografia = ""

forvalues yr = 2012(1)2021{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	* sample 1
	 * run code
	do "$code_dir\_definicoes_subamostra_area_geografica"
	* run code
	do "$code_dir\_definicoes_subamostra_composicao_demografica"
	* run code
	do "$code_dir\_definicoes_pnadcontinua_trimestral"
	* run code
	do "$code_dir\_numero_ocupados_por_ocupacao_2digitos"
	* save as temporary
	save "$tmp_dir\_temp_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2021{
	* call data
	append using "$tmp_dir\_temp_PNADC`yr'.dta"
}

* save in the output directory
compress
save "$output_dir\_amz_rr_numero_ocupados_por_ocupacao_2digitos.dta", replace

/////////////////////////////////////////////
//	Calcular o numero de ocupados e rendimento médio por atividade na Amazonia
//	(CNAE de 2 digitos)
//////////////////////////////////////////////

forvalues yr = 2012(1)2021{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	* sample 1
	 * run code
	do "$code_dir\_definicoes_subamostra_area_geografica"
	* run code
	do "$code_dir\_definicoes_subamostra_composicao_demografica"
	* run code
	do "$code_dir\_definicoes_pnadcontinua_trimestral"
	* run code
	do "$code_dir\_numero_ocupados_por_atividade_2digitos"
	* save as temporary
	save "$tmp_dir\_temp_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2021{
	* call data
	append using "$tmp_dir\_temp_PNADC`yr'.dta"
}

* save in the output directory
compress
save "$output_dir\_amz_rr_numero_ocupados_por_atividade_2digitos.dta", replace