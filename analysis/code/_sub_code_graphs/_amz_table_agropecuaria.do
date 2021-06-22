****** ****** ****** ****** ****** ****** ****** ****** ****** 
****** TABELA AGRREGADO AGROPECUARIA
****** ****** ****** ****** ****** ****** ****** ****** ****** 

* call data 
use "$input_dir\_numero_ocupados_por_setor.dta", clear

keep if Ano == 2019 | Ano == 2012

collapse (mean) n_ocu_str n_ocu_str_formal n_ocu_str_informal renda_media renda_formal renda_informal massa_salarial , by (cod_setor Ano)

* keep only observations that exist in 2019 and 2012
by cod_setor, sort: gen leao1 =_n
by cod_setor, sort: egen leao2 =max(leao1)
keep if leao2==2
drop leao*

cap drop if cod_setor=="."
cap drop if cod_setor==.
cap drop if cod_setor==""
cap drop if cod_setor=="0"

sort cod_setor Ano

* variacao absoluta
foreach var in n_ocu_str n_ocu_str_formal n_ocu_str_informal massa_salarial {
sort cod_setor Ano 
by cod_setor, sort: gen ops1_`var' = (`var'[_n] - `var'[_n-1]) 
by cod_setor, sort: egen delta_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* variacao relativa
foreach var in renda_media renda_formal renda_informal n_ocu_str n_ocu_str_formal n_ocu_str_informal massa_salarial {
sort cod_setor Ano 
by cod_setor, sort: gen ops1 = (`var'[_n]/`var'[_n-1])*100 -100
by cod_setor, sort: egen tx_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* percentual de formal
sort cod_setor Ano 
by cod_setor, sort: gen ops1 = (n_ocu_str_formal/n_ocu_str)*100
by cod_setor, sort: egen p_formal = mean(ops1) 
cap drop ops1


tostring Ano, replace

reshape wide n_ocu_str n_ocu_str_formal n_ocu_str_informal massa_salarial renda_media renda_formal renda_informal, i(cod_setor) j(Ano) string

gsort -delta_n_ocu_str

* keep agropecuaria
keep if cod_setor =="1"

//calcula o total
*do "${code_dir}/_calculo_total_cod2dig.do"

keep cod_setor delta_n_ocu_str tx_n_ocu_str tx_renda_media n_ocu_str2019 renda_media2019 p_formal 
order cod_setor delta_n_ocu_str tx_n_ocu_str tx_renda_media n_ocu_str2019 renda_media2019 p_formal 
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
mkmat delta_n_ocu_str tx_n_ocu_str tx_renda_media n_ocu_str2019 renda_media2019 p_formal, matrix(A) rownames(cod_setor)

* local notes
local ttitle "Ocupações que mais cresceram entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt("%16,0fc" "%16,1fc" "%16,1fc" "%16,0fc" "%16,0fc" "%16,1fc" "%16,1fc")) using "$output_dir\amztableagropecuaria.tex", 
	replace 
    prehead(
		"\begin{table}[H]"
		"\centering"
		"\label{amztableagropecuaria}"
		"\scalebox{0.56}{"
		"\begin{threeparttable}"
		"\caption{`ttitle'}"		
		"\begin{tabular}{l*{@span}{r}}"
		"\midrule \midrule"
		" &  \multicolumn{3}{c}{\textbf{Variação 2012-19}} & \multicolumn{3}{c}{\textbf{2019}} \\"	
		"\cmidrule(lr){2-4} \cmidrule(lr){5-7}"
		" & Emp. & Emp. & Rendi. & { Emp.} & { Rendi. } & {Formal} \\"
    )	
	collabels("total" "(\%)" "(\%)" "{total }" "{(R\\$)}" "(\%)" ) 	
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
	coeflabels(   /* run the follwing code:  label list cod_setor */
           1 "Agropecuária"
		  )
    ;
#delim cr

