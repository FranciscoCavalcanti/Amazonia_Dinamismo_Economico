******************************************************
**	 Tabela com varias colunas por grupamentos de atividade agregada 	**
******************************************************

* call data 
use "$input_dir\_amz_pa_numero_ocupados_por_atividade_2digitos.dta", clear
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

collapse (mean) n_ocu_cnae n_ocu_cnae_formal n_ocu_cnae_informal n_ocu_cnae_privado n_ocu_cnae_publico massa_salarial renda_media renda_formal renda_informal, by (nova_agregacao Ano)

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
foreach var in n_ocu_cnae n_ocu_cnae_formal n_ocu_cnae_informal n_ocu_cnae_privado n_ocu_cnae_publico massa_salarial {
sort nova_agregacao Ano 
by nova_agregacao, sort: gen ops1_`var' = (`var'[_n] - `var'[_n-1]) 
by nova_agregacao, sort: egen delta_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* variacao relativa
foreach var in renda_media renda_formal renda_informal n_ocu_cnae n_ocu_cnae_formal n_ocu_cnae_informal n_ocu_cnae_privado n_ocu_cnae_publico massa_salarial {
sort nova_agregacao Ano 
by nova_agregacao, sort: gen ops1 = (`var'[_n]/`var'[_n-1])*100 -100
by nova_agregacao, sort: egen tx_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* percentual de formal
sort nova_agregacao Ano 
by nova_agregacao, sort: gen ops1 = (n_ocu_cnae_formal/n_ocu_cnae)*100
by nova_agregacao, sort: egen p_formal = mean(ops1) 
cap drop ops1

* percentual de privado
by nova_agregacao, sort: gen ops1 = (n_ocu_cnae_privado/n_ocu_cnae)*100
by nova_agregacao, sort: egen p_privado = mean(ops1) 
cap drop ops1

reshape wide n_ocu_cnae n_ocu_cnae_formal n_ocu_cnae_informal n_ocu_cnae_privado n_ocu_cnae_publico massa_salarial renda_media renda_formal renda_informal, i(nova_agregacao) j(Ano) string

gsort -delta_n_ocu_cnae

keep nova_agregacao delta_n_ocu_cnae renda_media2019 tx_renda_media n_ocu_cnae2019 p_formal p_privado
order nova_agregacao delta_n_ocu_cnae renda_media2019 tx_renda_media n_ocu_cnae2019 p_formal p_privado
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
mkmat delta_n_ocu_cnae renda_media2019 tx_renda_media n_ocu_cnae2019 p_formal p_privado, matrix(A) rownames(nova_agregacao)

* local notes
local ttitle "Atividades econômicas que mais cresceram entre 2012 e 2019"
local tnotes "Fonte: com base nos dados da PNAD Contínua, IBGE"

#delim ;    
esttab matrix(A, fmt("%16,0fc" "%16,2fc" "%16,2fc" "%16,0fc" "%16,2fc" "%16,2fc")) using "$output_dir\amzpacnae2dig.tex", 
	replace 
    prehead(
        "\begin{table}[H]"
        "\centering"
		"\label{amzpacnae2dig}"
		"\scalebox{0.6}{"
        "\begin{threeparttable}"
        "\caption{`ttitle'}"		
        "\begin{tabular}{l*{@span}{r}}"
        "\midrule \midrule"
		" & { \bigtriangleup Ocup. } & { Rend. } & { Cresc.  } & { Ocup. } & { Formal (\%) } & { Privado (\%) } \\"
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
           1 "Administração pública, defesa e seguridade social"
           2 "Agricultura"
           3 "Alimentação"
           4 "Alimentos, bebidas e fumo"
           5 "Artes, cultura, esportes e recreação"
           6 "Atividades profissionais, científicas e técnicas"
           7 "Automóveis e equipamentos de transporte"
           8 "Comércio"
           9 "Construção"
          10 "Educação"
          11 "Eletricidade, gás, água e esgoto"
          12 "Eletrônicos, máquinas e equipamentos"
          13 "Eletrônicos, máquinas e equipamentos "
          14 "Estadia e turismo"
          15 "Extração mineral e de carvão, petróleo e gás"
          16 "Madeira, celulose e papel"
          17 "Móveis"
          18 "Organizações religiosas, sindicais e patronais"
          19 "Outros"
          20 "Pecuária"
          21 "Pesca e aquicultura"
          22 "Produtos de metal, minerais não-metálicos e metalurgia"
          23 "Produção florestal"
          24 "Químicos, farmacêuticos, borracha e plástico"
          25 "Saúde e assistência social"
          26 "Segurança e edifícios"
          27 "Serviços de escritório"
          28 "Serviços de informação e comunicação"
          29 "Serviços domésticos"
          30 "Serviços financeiros e de seguros"
          31 "Serviços pessoais (cabelereiros, lavanderias, etc.)"
          32 "Terceirização de mão-de-obra"
          33 "Transporte e correio"
          34 "Têxtil, vestuário, couro e calçados"
		  )
    ;
#delim cr

