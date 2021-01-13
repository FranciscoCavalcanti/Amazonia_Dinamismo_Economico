******************************************************
**	 Taxas de crescimento de ocupacoes por ocupacao	**
******************************************************

* call data 
use "$input_dir\_numero_ocupados_por_ocupacao.dta", clear
gen id = cod_ocupacao
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

collapse (mean) n_ocu_cod, by (cod_ocupacao Ano)

drop if cod_ocupacao=="."
drop if cod_ocupacao==""
drop if cod_ocupacao=="0"

sort cod_ocupacao Ano

by cod_ocupacao, sort: gen tx_crescimento = (n_ocu_cod[_n]/n_ocu_cod[_n-1])*100 -100

collapse (mean) tx_crescimento, by (cod_ocupacao)
sort tx_crescimento

* edit to merge
gen lgth=length(cod_ocupacao)
gen apnd = "" if  lgth==4
replace apnd = "0" if  lgth==3
replace apnd = "00" if  lgth==2
replace apnd = "000" if  lgth==1
replace apnd = "0000" if  lgth==0

gen aux1 = apnd + cod_ocupacao
replace cod_ocupacao = aux1
cap drop aux1 apnd lgth 

* merge with auxiliar data base
merge 1:1 cod_ocupacao using "$input_dir\cod_ocupacao.dta"
drop _merge
compress
gsort -tx_crescimento



drop if _n>10

* format
format tx_crescimento %16,2fc

// transforma data em matrix
mkmat tx_crescimento, matrix(A) rownames(cod_ocupacao)

* local notes
local ttitle "Taxas de crescimento de ocupações por tipo de ocupação"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt(%16,2fc)) using "$output_dir\rkngtxocuporocupacao.tex", 
	replace 
	collabels("Taxa de crescimento (\%)")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{rkngtxocuporocupacao}"
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
        9629 "Outras ocupações elementares não classificadas anteriormente" 
        7531 "Alfaiates, modistas, chapeleiros e peleteiros"
        5249 "Vendedores não classificados anteriormente" 
        5244 "Vendedores por telefone"
        7319 "Artesãos não classificados anteriormente"
        2619 "Profissionais em direito não classificados anteriormente"
        3251 "Dentistas auxiliares e ajudantes de odontologia"
        6114 "Agricultores e trabalhadores qualificados de cultivos mistos"
        5312 "Ajudantes de professores"
        3412 "Trabalhadores e assistentes sociais de nível médio"
    ) 
    ;
#delim cr

