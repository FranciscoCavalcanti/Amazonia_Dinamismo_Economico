******************************************************
**   Tabela com varias colunas por ocupacao agregada **
******************************************************

* call data 
use "$input_dir\_numero_ocupados_por_ocupacao_2digitos.dta", clear
gen group = "Amazônia Legal"
append using "$input_dir\_amz_ac_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Acre" if group == ""
append using "$input_dir\_amz_am_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Amazônia" if group == ""
append using "$input_dir\_amz_ap_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Amapá" if group == ""
append using "$input_dir\_amz_ma_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Maranhão" if group == ""
append using "$input_dir\_amz_mt_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Mato Grosso" if group == ""
append using "$input_dir\_amz_pa_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Pará" if group == ""
append using "$input_dir\_amz_ro_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Rondônia" if group == ""
append using "$input_dir\_amz_rr_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Roraima" if group == ""
append using "$input_dir\_amz_to_numero_ocupados_por_ocupacao_2digitos.dta"
replace group = "Tocantins" if group == ""

encode titulo, generate(nova_agregacao)
sort Ano Trimestre 

* generate variable of quartely date
	tostring Ano, replace
	tostring Trimestre, replace
	gen iten1 = Ano + "." + Trimestre
	gen  trim = quarterly(iten1, "YQ")
	drop iten*
		
* edit format
destring nova_agregacao, replace
format %tqCCYY trim	

drop if trim >= 240

******************************************************************
**	Numero absoluto entre trimestres de 2012 a 2020				**	
******************************************************************

drop if titulo==""

* generate variable that uniquely identify the observations
tostring nova_agregacao, gen(iten1)
gen iten2 = group + "-"+ iten1
encode iten2, gen(iten3)
gen uniquely_identify = iten3
cap drop iten*

keep if group == "Amazônia Legal"
* Ensino/saúde/segurança/dependência do setor publico
keep if nova_agregacao == 19 /* Profissionais da saúde
	*/	| nova_agregacao == 17  	/* Policiais, bombeiros e forças armadas
	*/ 	| nova_agregacao == 21  	/* Profissionais do ensino
	*/ 

keep if Ano == "2019" | Ano == "2012"

collapse (mean) n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal n_ocu_cod_privado n_ocu_cod_publico renda_media renda_formal renda_informal massa_salarial , by (titulo nova_agregacao Ano)


/*
collapse (sum) temp1 = n_ocu_cod temp2 = n_ocu_cod_formal temp3 = n_ocu_cod_informal (mean) renda_media [aw = n_ocu_cod], by (Ano)

collapse (sum) temp1 = n_ocu_cod temp2 = n_ocu_cod_formal temp3 = n_ocu_cod_informal (mean) renda_media, by (Ano)

collapse (sum) temp1 = n_ocu_cod temp2 = n_ocu_cod_formal temp3 = n_ocu_cod_informal (mean) renda_media [pw = n_ocu_cod], by (Ano)

collapse (mean) temp1 = n_ocu_cod temp2 = n_ocu_cod_formal temp3 = n_ocu_cod_informal renda_media [aw = n_ocu_cod], by (Ano)


*/


preserve
collapse (sum) n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal n_ocu_cod_privado n_ocu_cod_publico massa_salarial, by (Ano)
gen titulo = "Total de ocupações relativas ao setor público"
tempfile base_total
save  `base_total', replace
restore


preserve
collapse (mean) renda_media [aw = n_ocu_cod], by (Ano)
gen titulo = "Total de ocupações relativas ao setor público"
tempfile base_renda_media
save  `base_renda_media', replace
restore

preserve
use `base_renda_media', clear
merge 1:1 titulo Ano using  `base_total'
tempfile append_this_database
save  `append_this_database', replace
restore

append using `append_this_database', force

* variacao absoluta
foreach var in n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial {
sort titulo Ano 
by titulo, sort: gen ops1_`var' = (`var'[_n] - `var'[_n-1]) 
by titulo, sort: egen delta_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* variacao relativa
foreach var in renda_media renda_formal renda_informal n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial {
sort titulo Ano 
by titulo, sort: gen ops1 = (`var'[_n]/`var'[_n-1])*100 -100
by titulo, sort: egen tx_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* percentual de formal
sort titulo Ano 
by titulo, sort: gen ops1 = (n_ocu_cod_formal/n_ocu_cod)*100
by titulo, sort: egen p_formal = mean(ops1) 
cap drop ops1

* percentual de privado
sort titulo Ano 
by titulo, sort: gen ops1 = (n_ocu_cod_privado/n_ocu_cod)*100
by titulo, sort: egen p_privado = mean(ops1) 
cap drop ops1


tostring Ano, replace

cap keep n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial renda_media renda_formal renda_informal titulo Ano delta_n_ocu_cod delta_n_ocu_cod_formal delta_n_ocu_cod_informal delta_massa_salarial tx_renda_media tx_renda_formal tx_renda_informal tx_n_ocu_cod tx_n_ocu_cod_formal tx_n_ocu_cod_informal tx_massa_salarial p_formal p_privado
cap drop _merge


***
encode titulo, generate(nova_agregacao)
drop titulo


reshape wide n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial renda_media renda_formal renda_informal, i(nova_agregacao) j(Ano) string

gsort -delta_n_ocu_cod


keep nova_agregacao delta_n_ocu_cod tx_n_ocu_cod tx_renda_media n_ocu_cod2019 renda_media2019 p_formal p_privado
order nova_agregacao delta_n_ocu_cod tx_n_ocu_cod tx_renda_media n_ocu_cod2019 renda_media2019 p_formal p_privado
*drop if _n>20

* format
format delta_* %16,0fc

* format
format tx_* %16,2fc
format p_* %16,2fc

* format
format renda_*  %16,2fc

* format
format n_*  %16,0fc

// transforma data em matrix
mkmat delta_n_ocu_cod tx_n_ocu_cod tx_renda_media n_ocu_cod2019 renda_media2019 p_formal p_privado, matrix(A) rownames(nova_agregacao)

* local notes
local ttitle "Ocupações que mais cresceram entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt("%16,0fc" "%16,1fc" "%16,1fc" "%16,0fc" "%16,0fc" "%16,1fc" "%16,1fc")) using "$output_dir\amztablesetorpublico.tex", 
	replace 
    prehead(
		"\begin{table}[H]"
		"\centering"
		"\label{amztablesetorpublico}"
		"\scalebox{0.56}{"
		"\begin{threeparttable}"
		"\caption{`ttitle'}"		
		"\begin{tabular}{l*{@span}{r}}"
		"\midrule \midrule"
		" &  \multicolumn{3}{c}{\textbf{Variação 2012-19}} & \multicolumn{4}{c}{\textbf{2019}} \\"	
		"\cmidrule(lr){2-4} \cmidrule(lr){5-8}"
		" & Emp. & Emp. & Rendi. & { Emp.} & { Rendi. } & {Formal} & {Privado} \\"
    )	
	collabels("total" "(\%)" "(\%)" "{total }" "{(R\\$)}" "(\%)" "(\%)") 	
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
	coeflabels(   /* run the follwing code:  label list nova_agregacao */
		   17 "Policiais, bombeiros e forças armadas"
		   19 "Profissionais da saúde"
		   21 "Profissionais do ensino"
		   30 "Total de ocupações relativas ao setor público"		  
		  )
    ;
#delim cr