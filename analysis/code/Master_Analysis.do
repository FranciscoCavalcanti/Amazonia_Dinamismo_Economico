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
cap version 16.1 //always set the stata version being used
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
//	Analise
//////////////////////////////////////////////

* loop over do files
clear
cd  "${code_dir}/_sub_code"
pwd

* set do files
local files : dir . files "*.do"
display `files'

* loop over files
foreach xx in `files' {
	do "${code_dir}/_sub_code/`xx'"
}

//////////////////////////////////////////////
* delete temporary files
//////////////////////////////////////////////

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
