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
//	Analise para Amazônia Legal
//////////////////////////////////////////////
do "$code_dir\_amz.do"

//////////////////////////////////////////////
//	Analise por zonas rurais
//////////////////////////////////////////////
do "$code_dir\_amz_rural.do"

//////////////////////////////////////////////
//	Analise por zonas urbanas
//////////////////////////////////////////////
do "$code_dir\_amz_urbana.do"

//////////////////////////////////////////////
//	Analise para Regiao Metropolitana
//////////////////////////////////////////////
do "$code_dir\_amz_metropolitana.do"

//////////////////////////////////////////////
//	Analise setor Agricultura/Floresta
//////////////////////////////////////////////
do "$code_dir\_amz_floresta.do"

//////////////////////////////////////////////
//	Analise setor Tecnologia e Informacao
//////////////////////////////////////////////
do "$code_dir\_amz_ti.do"

//////////////////////////////////////////////
//	Analise entre jovens: 18 - 29 anos
//////////////////////////////////////////////
do "$code_dir\_amz_jovem.do"

//////////////////////////////////////////////
//	Analise para Mato Grosso
//////////////////////////////////////////////
do "$code_dir\_amz_mt.do"

//////////////////////////////////////////////
//	Analise para Maranhao
//////////////////////////////////////////////
*do "$code_dir\_amz_ma.do"

//////////////////////////////////////////////
//	Analise para Pará
//////////////////////////////////////////////
do "$code_dir\_amz_pa.do"

//////////////////////////////////////////////
//	Analise para Acre
//////////////////////////////////////////////
do "$code_dir\_amz_ac.do"

//////////////////////////////////////////////
//	Analise para Amazonas
//////////////////////////////////////////////
do "$code_dir\_amz_am.do"

//////////////////////////////////////////////
//	Analise para Amapa
//////////////////////////////////////////////
do "$code_dir\_amz_ap.do"

//////////////////////////////////////////////
//	Analise para Rondonia
//////////////////////////////////////////////
do "$code_dir\_amz_ro.do"

//////////////////////////////////////////////
//	Analise para Roraima
//////////////////////////////////////////////
do "$code_dir\_amz_rr.do"

//////////////////////////////////////////////
//	Analise para Tocantins
//////////////////////////////////////////////
do "$code_dir\_amz_to.do"

//////////////////////////////////////////////
//	Analise para Manaus
//////////////////////////////////////////////
do "$code_dir\_amz_manaus.do"

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

* clear all
clear all
