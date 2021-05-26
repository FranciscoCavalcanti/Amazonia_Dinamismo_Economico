***********************
* calcula o total
***********************
preserve

collapse  (sum) n_ocu_cod*
gen nova_agregacao = "Total"

tempfile soma_total

save `soma_total', replace

restore

***********************
* calcula media ponderada 1
***********************
preserve

collapse (mean) renda_media2012 [aweight=n_ocu_cod2012]

gen nova_agregacao = "Total"

merge 1:1  nova_agregacao using `soma_total'
drop _merge

tempfile media_ponderada1

save `media_ponderada1', replace

restore

***********************
* calcula media ponderada 2
***********************
preserve

collapse (mean) renda_media2019 [aweight=n_ocu_cod2019]

gen nova_agregacao = "Total"

merge 1:1  nova_agregacao using `media_ponderada1'
drop _merge

tempfile media_ponderada2

save `media_ponderada2', replace

restore

***********************
* Edita a base
***********************
preserve

use `media_ponderada2', clear

* variacao absoluta
foreach var in n_ocu_cod n_ocu_cod_formal n_ocu_cod_privado n_ocu_cod_publico {
sort nova_agregacao  
by nova_agregacao, sort: gen ops1_`var' = (`var'2019 - `var'2012) 
by nova_agregacao, sort: egen delta_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* variacao relativa
foreach var in renda_media n_ocu_cod n_ocu_cod_formal n_ocu_cod_privado n_ocu_cod_publico {
sort nova_agregacao 
by nova_agregacao, sort: gen ops1 = (`var'2019/`var'2012)*100 -100
by nova_agregacao, sort: egen tx_`var' = mean(ops1) // important for command reshape latter on
cap drop ops1
}

* percentual de formal
sort nova_agregacao 
by nova_agregacao, sort: gen ops1 = (n_ocu_cod_formal2019/n_ocu_cod2019)*100
by nova_agregacao, sort: egen p_formal = mean(ops1) 
cap drop ops1

* percentual de privado
by nova_agregacao, sort: gen ops1 = (n_ocu_cod_privado2019/n_ocu_cod2019)*100
by nova_agregacao, sort: egen p_privado = mean(ops1) 
cap drop ops1

keep nova_agregacao delta_n_ocu_cod tx_n_ocu_cod tx_renda_media n_ocu_cod2019 renda_media2019 p_formal p_privado
order nova_agregacao delta_n_ocu_cod tx_n_ocu_cod tx_renda_media n_ocu_cod2019 renda_media2019 p_formal p_privado

tempfile base_unida

save `base_unida', replace

restore

***********************
* junta obs novas na base original
***********************
append using `base_unida', force

recode nova_agregacao (. = 30) 
label define nova_agregacao 30 "Total", add
