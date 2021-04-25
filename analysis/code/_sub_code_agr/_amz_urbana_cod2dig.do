******************************************************
**	 Tabela com varias colunas por ocupacao agregada **
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

keep nova_agregacao delta_n_ocu_cod renda_media2019 tx_renda_media n_ocu_cod2019 p_formal p_privado
order nova_agregacao delta_n_ocu_cod renda_media2019 tx_renda_media n_ocu_cod2019 p_formal p_privado
drop if _n>20

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
mkmat delta_n_ocu_cod renda_media2019 tx_renda_media n_ocu_cod2019 p_formal p_privado, matrix(A) rownames(nova_agregacao)

* local notes
local ttitle "Ocupações que mais cresceram entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt("%16,0fc" "%16,2fc" "%16,2fc" "%16,0fc" "%16,2fc" "%16,2fc")) using "$output_dir\amzurbanacod2dig.tex", 
	replace 
  prehead(
    "\begin{table}[H]"
    "\centering"
    "\label{amzurbanacod2dig}"
    "\scalebox{0.6}{"
    "\begin{threeparttable}"
    "\caption{`ttitle'}"		
    "\begin{tabular}{l*{@span}{rrrrrrr}}"
    "\midrule \midrule"
    " & { \bigtriangleup Emp. } & { Rend. } & { Cresc.  } & { Emp. } & { Formal (\%) } & { Privado (\%) } \\"
  )
  collabels("{ }" "{ 2019 (R\\$) }" "{ Rend. (\%) }" "{ Total }" "{  }" "{  }") 
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
           1 "Administração de empresas"
           2 "Agricultura"
           3 "Alimentação"
           4 "Ambulantes"
           5 "Apoio administrativo"
           6 "Artesões e artes gráficas"
           7 "Atendimento direto ao público"
           8 "Ciências e engenharia"
           9 "Coletores de lixo"
          10 "Direito, ciências sociais e culturais"
          11 "Dirigentes e gerentes"
          12 "Domésticos"
          13 "Eletricidade e eletrônica"
          14 "Escriturários"
          15 "Forças armadas, policias e bombeiros"
          16 "Governo"
          17 "Informação e comunicação "
          18 "Montadores e condutores de veículos"
          19 "Operários da construção, metalurgia e indústria"
          20 "Operários de processamento e instalações"
          21 "Pecuária e criação de animais"
          22 "Produção florestal"
          23 "Profissionais da saúde"
          24 "Profissionais do ensino"
          25 "Proteção e segurança"
          26 "Serviços e cuidados pessoais"
          27 "Vendedores"
		) 
    ;
#delim cr

