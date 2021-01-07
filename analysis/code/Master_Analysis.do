* Francisco Cavalcanti
* Website: https://sites.google.com/view/franciscocavalcanti/
* GitHub: https://github.com/FranciscoCavalcanti
* Twitter: https://twitter.com/Franciscolc85
* LinkedIn: https://www.linkedin.com/in/francisco-de-lima-cavalcanti-5497b027/

/*
O propostio desse do file é:
Gerar tabelas e gráficos para mapear as ocupações e os setores econômicos mais promissores na Amazônia
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

global tmp_dir			"${ROOT}\Amazonia_Dinamismo_Economico\analysis\tmp"   
global code_dir			"${ROOT}\Amazonia_Dinamismo_Economico\analysis\code"   
global output_dir		"${ROOT}\Amazonia_Dinamismo_Economico\analysis\output"   
global input_dir		"${ROOT}\Amazonia_Dinamismo_Economico\build\output"   

* set more off 
set more off, perm

//////////////////////////////////////////////
//	Importancia relativa
//////////////////////////////////////////////

do "$code_dir\_importancia_relativa.do"

//////////////////////////////////////////////////////
//	Rankings de crescimento de absoluto de ocupações
//////////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_rkng_n_ocu_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_rkng_n_ocu_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_rkng_n_ocu_por_ocupacao.do"

//////////////////////////////////////////////////
//	Rankings de taxa de crescimento de ocupações 
//////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_rkng_tx_ocu_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_rkng_tx_ocu_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_rkng_tx_ocu_por_ocupacao.do"

//////////////////////////////////////////////////
//	Rankings de taxa de crescimento de salários 
//////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_rkng_tx_renda_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_rkng_tx_renda_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_rkng_tx_renda_por_ocupacao.do"

//////////////////////////////////////////////
//	Analise por zonas rurais e zonas urbanas	
//////////////////////////////////////////////
	
* delete temporary files

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
