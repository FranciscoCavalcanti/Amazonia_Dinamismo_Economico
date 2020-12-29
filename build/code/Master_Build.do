* Francisco Cavalcanti
* Website: https://sites.google.com/view/franciscocavalcanti/
* GitHub: https://github.com/FranciscoCavalcanti
* Twitter: https://twitter.com/Franciscolc85
* LinkedIn: https://www.linkedin.com/in/francisco-de-lima-cavalcanti-5497b027/

/*
O propostio desse do file é:
limpar os dados brutos da PNAD Contínua Trimestral e Anual
*/

* Stata version
version 16.1 //always set the stata version being used
set more off, perm

// caminhos (check your username by typing "di c(username)" in Stata) ----
if "`c(username)'" == "Francisco"   {
    global ROOT "C:\Users\Francisco\Dropbox\DataZoom"
}
else if "`c(username)'" == "f.cavalcanti"   {
    global ROOT "C:\Users\Francisco\Dropbox\DataZoom"
}	

global input_basiic		"${ROOT}\BasesIBGE\datazoom_rar\PNAD_CONTINUA\pnadcontinua_trimestral_20190729\pnad_painel\basico"  
global input_advanc     "${ROOT}\BasesIBGE\datazoom_rar\PNAD_CONTINUA\pnadcontinua_trimestral_20190729\pnad_painel\avancado"
global input_pnadanual	"${ROOT}\BasesIBGE\datazoom_rar\PNAD_CONTINUA\pnadcontinua_anual_20191016\Stata"      
global tmp_dir			"${ROOT}\Amazonia_Analise_Economia_Dinamica\build\tmp"   
global code_dir			"${ROOT}\Amazonia_Analise_Economia_Dinamica\build\code"   
global output_dir		"${ROOT}\Amazonia_Analise_Economia_Dinamica\build\output"   
global input_dir		"${ROOT}\Amazonia_Analise_Economia_Dinamica\build\input"   

* set more off 
set more off, perm


//////////////////////////////////////////////
//	
//	Calcular o numero de ocupados e rendimento médio por setores na Amazonia
//	
//////////////////////////////////////////////

**********************
**	Amazônia Legal	**
**********************

global area_geografica = "Amazônia Legal"

forvalues yr = 2012(1)2020{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	sample 1
	* run code
	do "$code_dir\_definicoes_pnadcontinua_trimestral"
	* run code
	do "$code_dir\_numero_ocupados_por_setor"
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
save "$output_dir\_numero_ocupados_por_setor.dta", replace

//////////////////////////////////////////////
//	
//	Calcular o numero de ocupados e rendimento médio por tipo de ocupação na Amazonia
//	
//////////////////////////////////////////////

**********************
**	Amazônia Legal	**
**********************

global area_geografica = "Amazônia Legal"

forvalues yr = 2012(1)2020{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	sample 1
	* run code
	do "$code_dir\_definicoes_pnadcontinua_trimestral"
	* run code
	do "$code_dir\_numero_ocupados_por_ocupacao"
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
save "$output_dir\_numero_ocupados_por_ocupacao.dta", replace

//////////////////////////////////////////////
//	
//	Calcular o numero de ocupados e rendimento médio por atividade na Amazonia
//	
//////////////////////////////////////////////

**********************
**	Amazônia Legal	**
**********************

global area_geografica = "Amazônia Legal"

forvalues yr = 2012(1)2020{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	sample 1
	* run code
	do "$code_dir\_definicoes_pnadcontinua_trimestral"
	* run code
	do "$code_dir\_numero_ocupados_por_atividade"
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
save "$output_dir\_numero_ocupados_por_atividade.dta", replace

******************************************
** delete temporary files
******************************************

cd  "${tmp_dir}/"
local datafiles: dir "${tmp_dir}/" files "*.dta"
foreach datafile of local datafiles {
        rm `datafile'
}

cd  "${tmp_dir}/"
local datafiles: dir "${tmp_dir}/" files "*.csv"
foreach datafile of local datafiles {
        rm `datafile'
}

cd  "${tmp_dir}/"
local datafiles: dir "${tmp_dir}/" files "*.txt"
foreach datafile of local datafiles {
        rm "`datafile'"
}


cd  "${tmp_dir}/"
local datafiles: dir "${tmp_dir}/" files "*.pdf"
foreach datafile of local datafiles {
        rm `datafile'
}
