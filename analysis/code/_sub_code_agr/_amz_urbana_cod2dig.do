******************************************************
**   Tabela com varias colunas por ocupacao agregada **
******************************************************

* call data 
use "$input_dir\_amz_urbana_numero_ocupados_por_ocupacao_2digitos.dta", clear
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
tsset nova_agregacao trim, quarterly 
format %tqCCYY trim	

******************************************************************
**	crescimento da media dos trimestres de 2012 a media 2019	**	
******************************************************************

* preserve
*preserve

keep if Ano == "2019" | Ano == "2012"

collapse (mean) n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal n_ocu_cod_privado n_ocu_cod_publico massa_salarial renda_media renda_formal renda_informal, by (nova_agregacao Ano)

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
foreach var in n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal n_ocu_cod_privado n_ocu_cod_publico massa_salarial {
sort nova_agregacao Ano 
by nova_agregacao, sort: gen ops1_`var' = (`var'[_n] - `var'[_n-1]) 
by nova_agregacao, sort: egen delta_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* variacao relativa
foreach var in renda_media renda_formal renda_informal n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal n_ocu_cod_privado n_ocu_cod_publico massa_salarial {
sort nova_agregacao Ano 
by nova_agregacao, sort: gen ops1 = (`var'[_n]/`var'[_n-1])*100 -100
by nova_agregacao, sort: egen tx_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* percentual de formal
sort nova_agregacao Ano 
by nova_agregacao, sort: gen ops1 = (n_ocu_cod_formal/n_ocu_cod)*100
by nova_agregacao, sort: egen p_formal = mean(ops1) 
cap drop ops1

* percentual de privado
by nova_agregacao, sort: gen ops1 = (n_ocu_cod_privado/n_ocu_cod)*100
by nova_agregacao, sort: egen p_privado = mean(ops1) 
cap drop ops1

reshape wide n_ocu_cod n_ocu_cod_formal n_ocu_cod_informal n_ocu_cod_privado n_ocu_cod_publico massa_salarial renda_media renda_formal renda_informal, i(nova_agregacao) j(Ano) string

gsort -delta_n_ocu_cod

//calcula o total
do "${code_dir}/_calculo_total_cod2dig.do"

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
esttab matrix(A, fmt("%16,0fc" "%16,1fc" "%16,1fc" "%16,0fc" "%16,0fc" "%16,1fc" "%16,1fc")) using "$output_dir\amzurbanacod2dig.tex", 
	replace 
    prehead(
		"\begin{table}[H]"
		"\centering"
		"\label{amzurbanacod2dig}"
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
           1 "Administração pública e de empresas"
           2 "Agricultores elementares"
           3 "Agricultores qualificados"
           4 "Ambulantes"
           5 "Apoio administrativo"
           6 "Artesões e artes gráficas"
           7 "Atendimento direto ao público"
           8 "Cientistas e engenheiros"
           9 "Coletores de lixo"
          10 "Dirigentes e gerentes"
          11 "Domésticos"
          12 "Escriturários"
          13 "Montadores e condutores de veículos"
          14 "Operários da construção, metalurgia e indústria"
          15 "Operários de processamento e instalações"
          16 "Pecuaristas e criadores de animais"
          17 "Policiais, bombeiros e forças armadas"
          18 "Produtores florestais"
          19 "Profissionais da saúde"
          20 "Profissionais de segurança"
          21 "Profissionais do ensino"
          22 "Profissionais em alimentação"
          23 "Serviços de TI e comunicação"
          24 "Serviços e cuidados pessoais"
          25 "Serviços financeiros e administrativos"
          26 "Serviços jurídicos, sociais e culturais"
          27 "Trabalhadores no governo"
          28 "Técnicos de eletricidade e eletrônica"
          29 "Vendedores"
          30 "Total"
		  )
    ;
#delim cr

