******************************************************
**	 Tabela com varias colunas por ocupacao agregada **
******************************************************

* call data 
use "$input_dir\_amz_urbana_numero_ocupados_por_ocupacao_2digitos.dta", clear
gen id = cod_cod2dig
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

* merge with aggregate data
merge n:1 cod_cod2dig using "$input_dir\cod_codagr.dta"
encode titulo, generate(nova_agregacao) 

************************************************************************
* calcular renda media ponderando pela nova quantidade
************************************************************************

* Rendimento medio habitual real dos ocupados total
by Ano Trimestre nova_agregacao, sort: egen iten1 = total(renda_media*n_ocu_cod)
by Ano Trimestre nova_agregacao, sort: egen iten2 = total(n_ocu_cod)
gen iten3 = (iten1/iten2)
replace renda_media = iten3
drop iten*
label variable renda_media "Rendimento médio habitual real dos ocupados (R$)"

* Rendimento medio habitual real dos ocupados formal total
by Ano Trimestre nova_agregacao, sort: egen iten1 = total(renda_formal*n_ocu_cod_formal)
by Ano Trimestre nova_agregacao, sort: egen iten2 = total(n_ocu_cod_formal)
gen iten3 = (iten1/iten2)
replace renda_formal = iten3
drop iten*
label variable renda_formal "Rendimento médio habitual real dos ocupados formal (R$)"

* Rendimento medio habitual real dos ocupados informal total
by Ano Trimestre nova_agregacao, sort: egen iten1 = total(renda_formal*n_ocu_cod_informal)
by Ano Trimestre nova_agregacao, sort: egen iten2 = total(n_ocu_cod_informal)
gen iten3 = (iten1/iten2)
replace renda_formal = iten3
drop iten*
label variable renda_informal "Rendimento médio habitual real dos ocupados informal (R$)"

************************************************************************
************************************************************************

collapse (sum) n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial 	/*
	*/ 	(mean) renda_media renda_formal renda_informal, by(Ano Trimestre nova_agregacao titulo)


******************************************************************
**	crescimento da media dos trimestres de 2012 a media 2019	**	
******************************************************************

* preserve
*preserve

keep if Ano == "2019" | Ano == "2012"

collapse (mean) n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial renda_media renda_formal renda_informal, by (nova_agregacao Ano)

* keep only observations that exist in 2019 and 2012
by nova_agregacao, sort: gen leao1 =_n
by nova_agregacao, sort: egen leao2 =max(leao1)
keep if leao2==2
drop leao*

cap drop if nova_agregacao=="."
cap drop if nova_agregacao==.
cap drop if nova_agregacao==""
cap drop if nova_agregacao=="0"

sort nova_agregacao Ano

* variacao absoluta
foreach var in n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial {
sort nova_agregacao Ano	
by nova_agregacao, sort: gen ops1_`var' = (`var'[_n] - `var'[_n-1])	
by nova_agregacao, sort: egen delta_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* variacao relativa
foreach var in renda_media renda_formal renda_informal n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial {
sort nova_agregacao Ano	
by nova_agregacao, sort: gen ops1 = (`var'[_n]/`var'[_n-1])*100 -100
by nova_agregacao, sort: egen tx_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}


reshape wide n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal massa_salarial renda_media renda_formal renda_informal, i(nova_agregacao) j(Ano) string


gsort -delta_n_ocu_cod
order nova_agregacao delta_n_ocu_cod tx_n_ocu_cod renda_media2012 renda_media2019 delta_massa_salarial tx_massa_salarial

* format
format delta_* %16,0fc

* format
format tx_* %16,2fc

* format
format renda_*  %16,2fc

* format
format n_*  %16,0fc

// transforma data em matrix
mkmat delta_n_ocu_cod tx_n_ocu_cod renda_media2012 renda_media2019 delta_massa_salarial tx_massa_salarial, matrix(A) rownames(nova_agregacao)

* local notes
local ttitle "Variação da massa de rendimentos por tipo de ocupação entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt(%16,2fc)) using "$output_dir\teste.tex", 
	replace 
	collabels("{R\\$}")
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{amzurbanarkngvmassaporcod2dig}"
		"\scalebox{0.70}{"
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
        coeflabels(   /* run the follwing code:  label list nova_agregacao */
           1 "Administração pública"
           2 "Agricultura, pecuária e produção florestal"
           3 "Apoio administrativo"
           4 "Dirigentes e gerentes"
           5 "Forças armadas e militatres"
           6 "Operários da construção e metalurgia qualificados"
           7 "Profissionais de nível médio"
           8 "Profissionais em administração"
           9 "Profissionais em ciências e engenharia"
          10 "Profissionais em direito, ciências sociais e culturais"
          11 "Profissionais em saúde"
          12 "Profissionais em tecnologias da informação"
          13 "Serviços pessoais, cuidado e proteção"
          14 "Trabalhadores domésticos"
          15 "Vendedores"		
		) 
    ;
#delim cr

