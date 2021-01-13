******************************************************
**	 Taxas de crescimento de ocupacoes por grupamentos de atividade	**
******************************************************

* call data 
use "$input_dir\_numero_ocupados_por_atividade.dta", clear
gen id = cod_atividade
sort Ano Trimestre 

* generate variable of quartely date
	tostring Ano, replace
	tostring Trimestre, replace
	gen iten1 = Ano + "." + Trimestre
	gen  trim = quarterly(iten1, "YQ")
	drop iten*
		
* edit format
destring id, replace
tsset id trim, quarterly 
format %tqCCYY trim	


******************************************************************
**	crescimento da media dos trimestres de 2012 a media 2019	**	
******************************************************************

* preserve
*preserve

keep if Ano == "2019" | Ano == "2012"

collapse (mean) n_ocu_cnae, by (cod_atividade Ano)

drop if cod_atividade=="."
drop if cod_atividade==""
drop if cod_atividade=="0"

sort cod_atividade Ano

by cod_atividade, sort: gen tx_crescimento = (n_ocu_cnae[_n]/n_ocu_cnae[_n-1])*100 -100

collapse (mean) tx_crescimento, by (cod_atividade)
sort tx_crescimento

* edit to merge
gen lgth=length(cod_atividade)
gen apnd = "" if  lgth==5
replace apnd = "0" if  lgth==4
replace apnd = "00" if  lgth==3
replace apnd = "000" if  lgth==2
replace apnd = "0000" if  lgth==1
replace apnd = "00000" if  lgth==0
gen aux1 = apnd + cod_atividade
replace cod_atividade = aux1
cap drop aux1 apnd lgth 

* merge with auxiliar data base
merge 1:1 cod_atividade using "$input_dir\cod_atividade.dta"
drop _merge
compress
gsort -tx_crescimento

drop if _n>10

* format
format tx_crescimento %16,2fc

// transforma data em matrix
mkmat tx_crescimento, matrix(A) rownames(cod_atividade)

* local notes
local ttitle "Taxas de crescimento de ocupações por grupamentos de atividade"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt(%16,2fc)) using "$output_dir\rkngtxocuporatividade.tex", 
	replace 
	collabels("Taxa de crescimento (\%)")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{rkngtxocuporatividade}"
		"\scalebox{0.60}{"
        "\begin{threeparttable}"
        "\caption{`ttitle'}"		
        "\begin{tabular}{l*{@span}{r}}"
        "\midrule \midrule"
    )
    postfoot(
        "\bottomrule"
        "\end{tabular}"		
        "\begin{tablenotes}"
        "\item \scriptsize{`tnotes'}"
        "\end{tablenotes}"
        "\end{threeparttable}"
		"}"
        "\end{table}"
    )    
	label
    unstack 
	noobs 
	nonumber 
	nomtitle
        coeflabels(
        78000 "Seleção, agenciamento e locação de mão-de-obra" 
        53002 "Atividades de malote e de entrega"
        86009 "Atividades de atenção à saúde humana não especificadas anteriormente" 
        84017 "Outros serviços coletivos prestados pela administração pública - Municipal"
        14002 "Confecção, sob medida, de artigos do vestuário"
        21000 "Fabricação de produtos farmoquimicos e farmacêuticos"
        56020 "Serviços ambulantes de alimentação"
        17002 "Fabricação de embalagens e de produtos diversos de papel, cartolina, papel-cartão e papelão ondulado"
        01107 "Cultivo de soja"
        01112 "Cultivo de frutas cítricas"
    ) 
    ;
#delim cr

