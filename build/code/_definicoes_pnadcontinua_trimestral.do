**********************
**	 Definitions	**
**********************

/*	Useful variables: Income

VD4016: 
Rendimento mensal habitual do trabalho principal para pessoas de 14 anos ou mais de idade 
(apenas para pessoas que receberam em dinheiro, produtos ou mercadorias no trabalho principal)

VD4019
Rendimento mensal habitual de todos os trabalhos para pessoas de 14 anos ou mais de idade 
(apenas para pessoas que receberam em dinheiro, produtos ou mercadorias em qualquer trabalho)

*/

/*	Useful variables: Labor

VD4001
1 // Pessoas na força de trabalho
2 // Pessoas fora da força de trabalho

VD4002
1 // Pessoas ocupadas 
2 // Pessoas desocupadas 

VD4009
1 // Empregado no setor privado com carteira de trabalho assinada
2 // Empregado no setor privado sem carteira de trabalho assinada
3 // Trabalhador doméstico com carteira de trabalho assinada
4 // Trabalhador doméstico sem carteira de trabalho assinada
5 // Empregado no setor público com carteira de trabalho assinada
6 // Empregado no setor público sem carteira de trabalho assinada
7 // Militar e servidor estatutário
8 // Empregador
9 // Conta-própria
10 // Trabalhador familiar auxiliar
. // Não aplicável

*/

**************************************
** Definição de Área Geográfica 	**
**************************************

if "$area_geografica" == "Amazônia Legal"   {
    keep if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)
	
	local area = "amazonia_legal"
}
else if "$area_geografica" == "Amazônia Legal Rural"   {
    keep if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	gen domicilio_rural = 0
	replace domicilio_rural = 1 if V1022 ==2 // 2 Rural
	keep if domicilio_rural==1
}
else if "$area_geografica" == "Amazônia Legal Urbana"   {
    keep if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	gen domicilio_urbano = 0
	replace domicilio_urbano = 1 if V1022 ==1 // 1 Urbana
	keep if domicilio_urbano==1
}	
else if "$area_geografica" == "Resto do Brasil"   {
    drop if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	local area = "resto_brasil"
}
else if "$area_geografica" == "Mato Grosso"   {
    keep if UF == 51 	// Mato Grosso

	local area = "mato_grosso"
}	
else if "$area_geografica" == "Pará"   {
    keep if UF == 15 	// Pará

	local area = "para"
}		
else if "$area_geografica" == "Manaus"   {
    keep if UF == 13 & (V1023 == 1 | V1023 == 2) 	// Amazonas & Capital | Resto da RM (Região Metropolitana, excluindo a capital)

	local area = "manaus"
}	

**********************************
**	Definições de variáveis 	**
**********************************

* rendimento de todos os trabalhos
gen rendatotal =  VD4019 	// Rendimento mensal habitual de todos os trabalhos
replace rendatotal = 0 if rendatotal ==. 

* pessoa ocupado
gen ocupado = 1 if VD4002 == 1 	// Pessoas ocupadas 
replace ocupado = 0 if ocupado ==. 

* pessoa desocupado
gen desocupado = 1 if VD4002 == 2 	// Pessoas desocupadas 
replace desocupado = 0 if desocupado ==. 

** trabalhador formal
gen formal =.
replace formal = 1 if VD4002 == 1 &  VD4009 == 1 	// Empregado no setor privado com carteira de trabalho assinada
replace formal = 1 if VD4002 == 1 &  VD4009 == 3 	// Trabalhador doméstico com carteira de trabalho assinada
replace formal = 1 if VD4002 == 1 &  VD4009 == 5 	// Empregado no setor público com carteira de trabalho assinada
replace formal = 1 if VD4002 == 1 &  VD4009 == 7 	// Militar e servidor estatutário
replace formal = 1 if VD4002 == 1 &  VD4009 == 9 & VD4012 == 1  // Conta-própria & Contribuinte
replace formal = 1 if VD4002 == 1 &  VD4009 == 8  & VD4012 == 1  // Empregador & Contribuinte
replace formal = 0 if formal ==.

** trabalhador informal
gen informal =.
replace informal = 1 if VD4002 == 1 &  VD4009 == 2 	// Empregado no setor privado sem carteira de trabalho assinada 
replace informal = 1 if VD4002 == 1 &  VD4009 == 4 	// Trabalhador doméstico sem carteira de trabalho assinada
replace informal = 1 if VD4002 == 1 &  VD4009 == 6 	// Empregado no setor público sem carteira de trabalho assinada
replace informal = 1 if VD4002 == 1 &  VD4009 == 9 & VD4012 == 2 	// Conta-própria & Não contribuinte
replace informal = 1 if VD4002 == 1 &  VD4009 == 10 	// Trabalhador familiar auxiliar
replace informal = 1 if VD4002 == 1 &  VD4009 == 8  & VD4012 == 2  // Empregador & Não contribuinte
replace informal = 0 if informal ==. 

* pessoa na força de trabalho
gen forcatrabalho = 1 if VD4001 == 1 	// Pessoas na força de trabalho
replace forcatrabalho = 0 if forcatrabalho ==. 

* pessoa fora da força de trabalho
gen forcatrabalhofora = 1 if VD4001 == 2	// Pessoas fora da força de trabalho
replace forcatrabalhofora = 0 if forcatrabalhofora ==. 

* pessoa com idade ativa
gen pia = 1 if V2009 >= 14	// PIA = pessoas em idade de trabalhar inclui as pessoas de 14 anos
replace forcatrabalhofora = 0 if forcatrabalhofora ==. 

* pessoa com economicamente ativa
gen pea = 1 if VD4002 ==1 | VD4002 ==2  // PEA = população ocupada + população desocupada
replace pea = 0 if pea ==. 

* pessoa inativa
gen inativa = 1 if VD4001 == 2  // população desocupada
replace inativa = 0 if inativa ==. 

* pessoa desempregado
gen desempregado = 1 if VD4001 == 1 & VD4002 == 2 // pessoa na força de trabalho & população desocupada
replace desempregado = 0 if desempregado ==. 

* pessoa desalentada (não tomou tomou alguma providência para conseguir trabalho)
* ou V4074 =3 Desistiu de procurar por não conseguir encontrar trabalho
* e
* V4074 =4  Acha que não vai encontrar trabalho por ser muito jovem ou muito idoso
gen desalento = 1 if VD4005 ==1 // Pessoas desalentadas
replace desalento = 0 if desalento ==. 

* pessoa nem-nem
gen nemnem = 1 if VD4002 ==2  // população desocupada
cap replace nemnem = 1 if VD4001 == 2 & V3002 == 2 // Fora da força de trabalho e não estuda
cap replace nemnem = 0 if V3002 == 1 // frequenta escola? Sim
cap replace nemnem = 0 if V4074 == 6 // Qual foi o principal motivo de não ter tomado providência para conseguir trabalho? Estudo
cap replace nemnem = 0 if V4074A == 8 // Estava estudando (curso de qualquer tipo ou por conta própria)
replace nemnem = 0 if nemnem ==. 

* pessoa empregado SC
gen empregadoSC = 1 if VD4009 == 2 | VD4009 == 4 | VD4009 == 6 | VD4009 == 10 // trabalhadores informais
replace empregadoSC = 0 if empregadoSC ==. 

* pessoa empregado CC
gen empregadoCC = 1 if VD4009 == 1 | VD4009 == 3 | VD4009 == 5  // trabalhadores formais
replace empregadoCC = 0 if empregadoCC ==. 

* pessoa conta-própria
gen cpropria = 1 if VD4009 == 9  // conta-própria
replace cpropria = 0 if cpropria ==. 

* pessoa conta-própria contribuinte
gen cpropriaC = 1 if VD4009 == 9 & VD4012 == 1  // Conta-própria & Contribuinte
replace cpropriaC = 0 if cpropriaC ==. 

* pessoa conta-própria não-contribuinte
gen cpropriaNc = 1 if VD4009 == 9 & VD4012 == 2  // Conta-própria & Não contribuinte
replace cpropriaNc = 0 if cpropriaNc ==. 

* pessoa empregador
gen empregador = 1 if VD4009 == 8  // empregador
replace empregador = 0 if empregador ==. 

* pessoa militar e servidor estatutário
gen militar = 1 if VD4009 == 7  // militar e servidor estatutário
replace militar = 0 if militar ==. 

* trabalhadores em casa
gen homeoffice = 1 if   V4022 == 4  // No domicílio de residência, em local exclusivo para o desempenho da atividade
replace homeoffice = 1 if   V4022 == 5 // No domicílio de residência, sem local exclusivo para o desempenho da atividade 
replace homeoffice = 0 if homeoffice ==. 

* grandes setores da economia
gen gstr_agricultura = 1 if VD4010 == 1 	// Agricultura
gen gstr_industria = 1 if VD4010 == 2 	// Indústria geral
gen gstr_construcao = 1 if VD4010 == 3 	// Construção
gen gstr_comercio = 1 if VD4010 == 4 	// Comércio, reparação de veículos automotores e motocicletas
gen gstr_servicos = 1 if VD4010 >= 5 	// 

* Grupamentos de atividade principal do empreendimento do trabalho 
gen gape_agricultura = 1 if VD4010 == 1 	// Agricultura, pecuária, produção florestal, pesca e aquicultura 
gen gape_industria = 1 if VD4010 == 2 	// Indústria geral
gen gape_construcao = 1 if VD4010 == 3 	// Construção
gen gape_comercio = 1 if VD4010 == 4 	// Comércio, reparação de veículos automotores e motocicletas
gen gape_transporte = 1 if VD4010 == 5 	// Transporte, armazenagem e correio 
gen gape_alimentacao = 1 if VD4010 == 6 	// Alojamento e alimentação 
gen gape_informacao = 1 if VD4010 == 7 	// Informação, comunicação e atividades financeiras, imobiliárias, profissionais e administrativas
gen gape_publica = 1 if VD4010 == 8 	// Administração pública, defesa e seguridade social 
gen gape_educacao = 1 if VD4010 == 9 	// Educação, saúde humana e serviços sociais
gen gape_outros  = 1 if VD4010 == 10 	// Outros Serviços
gen gape_domestico = 1 if VD4010 == 11 	// Serviços domésticos

* Sub-grupamentos de atividade principal do empreendimento do trabalho 
** agricultura
gen sgap_agricultura = 1 if V4013 >= 1101 & V4013 <= 1119
replace sgap_agricultura = 1 if V4013 == 1401
gen sgap_animal = 1 if V4013 >= 1201 & V4013 <= 1209
replace sgap_animal = 1 if V4013 == 1402
replace sgap_animal = 1 if V4013 == 1500
replace sgap_animal = 1 if V4013 == 1999
replace sgap_animal = 1 if V4013 == 3001
replace sgap_animal = 1 if V4013 == 3002
gen sgap_florestal = 1 if V4013 == 2000
** industria
gen sgap_extrativa = 1 if V4013 >= 5000 & V4013 <= 9000
gen sgap_trans = 1 if V4013 >= 10010 & V4013 <= 33002
gen sgap_energia = 1 if V4013 >= 35010 & V4013 <= 35022
gen sgap_agua = 1 if V4013 >= 36000 & V4013 <= 39000

*** industria de transformacao
gen sgap_trans01 = 1 if V4013 >= 10010 & V4013 <= 11000 // FABRICAÇÃO DE PRODUTOS ALIMENTÍCIOS
gen sgap_trans02 = 1 if V4013 >= 13001 & V4013 <= 15020 // FABRICAÇÃO DE PRODUTOS TÊXTEIS
														// CONFECÇÃO DE ARTIGOS DO VESTUÁRIO E ACESSÓRIOS
														// PREPARAÇÃO DE COUROS E FABRICAÇÃO DE ARTEFATOS DE COURO, ARTIGOS DE VIAGEM E CALÇADOS
gen sgap_trans03 = 1 if V4013 >= 16001 & V4013 <= 17002 // FABRICAÇÃO DE PRODUTOS DE MADEIRA
														// FABRICAÇÃO DE CELULOSE, PAPEL E PRODUTOS DE PAPEL
replace sgap_trans03 = 1 if sgap_trans03 ==. & V4013 == 18000  // IMPRESSÃO E REPRODUÇÃO DE GRAVAÇÕES

gen sgap_trans04 = 1 if V4013 >= 19010 & V4013 <= 22020 // FABRICAÇÃO DE PRODUTOS QUÍMICOS
gen sgap_trans05 = 1 if V4013 >= 23010 & V4013 <= 25002 // FABRICAÇÃO DE PRODUTOS DE MINERAIS NÃO-METÁLICOS
gen sgap_trans06 = 1 if V4013 >= 26010 & V4013 <= 28000 // FABRICAÇÃO DE MÁQUINAS E EQUIPAMENTOS
gen sgap_trans07 = 1 if V4013 >= 29001 & V4013 <= 30090 // FABRICAÇÃO DE EQUIPAMENTOS DE TRANSPORTE
gen sgap_trans08 = . // OUTROS
replace sgap_trans08 = 1 if sgap_trans08 ==. & V4013 >= 31000 & V4013 <= 33002 // FABRICAÇÃO DE MÓVEIS
replace sgap_trans08 = 1 if sgap_trans08 ==. & V4013 == 12000  // FABRICAÇÃO DE PRODUTOS DO FUMO

* Faixa educacional
gen faixa_educ1 = 1 if VD3004 ==1 	// Sem instrução e menos de 1 ano de estudo
gen faixa_educ2 = 1 if VD3004 ==2 	// Fundamental incompleto ou equivalente 
gen faixa_educ3 = 1 if VD3004 ==3 	// Fundamental completo ou equivalente
gen faixa_educ4 = 1 if VD3004 ==4 	// Médio incompleto ou equivalente
replace faixa_educ4 = 1 if VD3004 ==5 	// Médio completo ou equivalente
replace faixa_educ4 = 1 if VD3004 ==6 	// Superior incompleto ou equivalente
gen faixa_educ5 = 1 if VD3004 ==7 	// Superior completo 

* Faixa etaria
gen faixa_etaria1 = 1 if V2009 >= 14 & V2009 <= 17
gen faixa_etaria2 = 1 if V2009 >= 18 & V2009 <= 24
gen faixa_etaria3 = 1 if V2009 >= 25 & V2009 <= 29
gen faixa_etaria4 = 1 if V2009 >= 30 & V2009 <= 39
gen faixa_etaria5 = 1 if V2009 >= 40 & V2009 <= 49
gen faixa_etaria6 = 1 if V2009 >= 50 & V2009 <= 59
gen faixa_etaria7 = 1 if V2009 >= 60

* Faixa genero
gen faixa_genero1 = 1 if V2007 ==1 // 1 Homem
gen faixa_genero2 = 1 if V2007 ==2 // 1 Mulher

* area_regiao_metropolitana
gen faixa_metro = 1 if V1023 == 1 	//  Capital
replace faixa_metro = 1 if V1023 == 2 	// 	Resto da RM (Região Metropolitana, excluindo a capital)

* area_nregiao_metropolitana
gen faixa_nmetro = 1 if V1023 == 3 	//  Resto da RIDE (Região Integrada de Desenvolvimento Econômico, excluindo a capital) 
replace faixa_nmetro = 1 if V1023 == 4 	// 	Resto da UF  (Unidade da Federação, excluindo a região metropolitana e a RIDE)

* area_regiao_metropolitana
gen faixa_rural = 1 if V1022 ==2 // 2 Rural

* area_nregiao_metropolitana
gen faixa_urbana = 1 if V1022 ==1 // 1 Urbana

**************************************
**	Editar variável trimestre 		**
** 									**
**	É útil ter valores contínuos 	**
**************************************
 
* generate variable of quartely date
	tostring Ano, gen(iten1)
	gen iten3 = iten1 + "." + Trimestre
	gen  trim = quarterly(iten3, "YQ")
	cap drop iten*
	cap drop tool*