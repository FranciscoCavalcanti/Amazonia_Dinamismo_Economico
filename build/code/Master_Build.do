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
cap version 16.1 //always set the stata version being used
set more off, perm

// caminhos (check your username by typing "di c(username)" in Stata) ----
if "`c(username)'" == "Francisco"   {
    global ROOT "C:\Users\Francisco\Dropbox\DataZoom"
    global DATABASE "C:\Users\Francisco\Dropbox\DataZoom"
}
else if "`c(username)'" == "DELL"   {
    global ROOT "C:/Users/DELL/Documents/GitHub"
    global DATABASE "D:\Dropbox\DataZoom"
}	

global input_advanc     "${DATABASE}\BasesIBGE\datazoom_rar\PNAD_CONTINUA\pnadcontinua_trimestral_20211130\pnad_continua_stata\avancado"
global input_pnadanual	"${DATABASE}\BasesIBGE\datazoom_rar\PNAD_CONTINUA\pnadcontinua_anual_20191016\Stata"      
global input_pnadcdoc	"${DATABASE}\BasesIBGE\datazoom_rar\PNAD_CONTINUA\pnadcontinua_trimestral_20190729\Documentacao"      
global tmp_dir			"${ROOT}\Amazonia_Dinamismo_Economico\build\tmp"   
global code_dir			"${ROOT}\Amazonia_Dinamismo_Economico\build\code"   
global output_dir		"${ROOT}\Amazonia_Dinamismo_Economico\build\output"   
global input_dir		"${ROOT}\Amazonia_Dinamismo_Economico\build\input"   

//////////////////////////////////////////////
//	
//	Descricao de codigos de atividades (agregado)
//	
//////////////////////////////////////////////
* run code
clear 
do "$code_dir\_cod_cnae2dig"


//////////////////////////////////////////////
//	
//	Descricao de codigos de ocupacao (agregado)
//	
//////////////////////////////////////////////
* run code
clear 
do "$code_dir\_cod_cod2dig"


//////////////////////////////////////////////
//	
//	Dinamismo Econômico na Amazonia Legal
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_legal"
clear


//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Maranhao
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_ma"
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
//	Dinamismo Econômico no Acre
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_ac"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Amazonas
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_am"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Amapa
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_ap"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Roraima
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_rr"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Rondonia
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_ro"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Tocantins
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_to"
clear

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
//	Dinamismo Econômico Entre os Escolarizados (com pelo menos ensino medio)
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_edu_h"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico Entre os Não Escolarizados (até ensino medio)
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_edu_l"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico Brasil (exceto Amazônia Legal)
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_resto"
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
