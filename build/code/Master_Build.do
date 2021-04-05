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
global input_pnadcdoc	"${ROOT}\BasesIBGE\datazoom_rar\PNAD_CONTINUA\pnadcontinua_trimestral_20190729\Documentacao"      
global tmp_dir			"${ROOT}\Amazonia_Dinamismo_Economico\build\tmp"   
global code_dir			"${ROOT}\Amazonia_Dinamismo_Economico\build\code"   
global output_dir		"${ROOT}\Amazonia_Dinamismo_Economico\build\output"   
global input_dir		"${ROOT}\Amazonia_Dinamismo_Economico\build\input"   

//////////////////////////////////////////////
//	
//	Descricao de codigos de atividades
//	
//////////////////////////////////////////////

* call data Atividade_CNAE_Domiciliar_2_0
import excel "$input_pnadcdoc\Atividade_CNAE_Domiciliar_2_0.xls", sheet("Estrutura CNAE Domiciliar 2.0") cellrange(A3:E335) firstrow clear

* clean data
cap gen titulo = Denominação 
cap gen cod_atividade = Classe
cap tostring cod_atividade, replace
keep if cod_atividade !=""
sort cod_atividade
keep cod_atividade titulo

* save in the output directory
compress
save "$output_dir\cod_atividade.dta", replace


//////////////////////////////////////////////
//	
//	Descricao de codigos de atividades (2 digitos)
//	
//////////////////////////////////////////////

* call data Atividade_CNAE_Domiciliar_2_0
import excel "$input_pnadcdoc\Atividade_CNAE_Domiciliar_2_0.xls", sheet("Estrutura CNAE Domiciliar 2.0") cellrange(A3:E335) firstrow clear

* clean data
cap gen titulo = Denominação 
cap gen cod_cnae2dig = Divisão
cap tostring cod_cnae2dig, replace
keep if cod_cnae2dig !=""
sort cod_cnae2dig
keep cod_cnae2dig titulo

* save in the output directory
compress
save "$output_dir\cod_cnae2dig.dta", replace

//////////////////////////////////////////////
//	
//	Descricao de codigos de ocupacao
//	
//////////////////////////////////////////////

* call data Ocupacao_COD
import excel "$input_pnadcdoc\Ocupacao_COD.xls", sheet("Estrutura COD") cellrange(A3:E617) firstrow clear

* clean data
cap gen titulo = Denominação 
cap gen cod_ocupacao = Grupodebase
cap tostring cod_ocupacao, replace
keep if cod_ocupacao !=""
sort cod_ocupacao
keep cod_ocupacao titulo

* save in the output directory
compress
save "$output_dir\cod_ocupacao.dta", replace

//////////////////////////////////////////////
//	
//	Descricao de codigos de ocupacao (2 digitos)
//	
//////////////////////////////////////////////

* call data Ocupacao_COD
import excel "$input_pnadcdoc\Ocupacao_COD.xls", sheet("Estrutura COD") cellrange(A3:E617) firstrow clear

* clean data
cap gen titulo = Denominação 
cap gen cod_cod2dig = Subgrupoprincipal
cap tostring cod_cod2dig, replace
keep if cod_cod2dig !=""
sort cod_cod2dig
keep cod_cod2dig titulo

* save in the output directory
compress
save "$output_dir\cod_cod2dig.dta", replace

//////////////////////////////////////////////
//	
//	Descricao de codigos de comida (definicoes por Salo V Coslovsky)
//	
//////////////////////////////////////////////

* call data for COD
import excel "$input_dir\Lista_corrida_COD_PNADC_SVC.xls", sheet("Sheet1") firstrow clear

* clean data
keep if Comidas==1
cap gen titulo = nome 
cap gen cod_ocupacao = codigo
cap tostring cod_ocupacao, replace
keep if cod_ocupacao !=""
sort cod_ocupacao
keep cod_ocupacao titulo

* save in the output directory
compress
save "$output_dir\cod_ocupacao_comidas.dta", replace

* call data for CNAE
import excel "$input_dir\Lista_corrida_CNAE_PNADC_SVC.xls", sheet("Sheet1") firstrow clear

* clean data
keep if Comidas==1
cap gen titulo = nome 
cap gen cod_atividade = codigo
cap tostring cod_atividade, replace
keep if cod_atividade !=""
sort cod_atividade
keep cod_atividade titulo

* save in the output directory
compress
save "$output_dir\cod_atividade_comidas.dta", replace


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
	* sample 1
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
compress
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
	* sample 1
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
compress
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
	* sample 1
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
compress
save "$output_dir\_numero_ocupados_por_atividade.dta", replace


//////////////////////////////////////////////
//	
//	Dinamismo Econômico na Zona Urbana da Amazônia
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_urbana"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico na Zona Rural da Amazônia
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_rural"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico Entre os Jovens da Amazônia
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_jovem"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Mato Grosso
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_mt"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Pará
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_pa"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico na região metropolitana de Manaus
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_manaus"
clear

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
