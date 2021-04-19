//////////////////////////////////////////////
//	
//	Descricao de codigos de ocupacao (agregado)
//	
//////////////////////////////////////////////

* call data Ocupacao_COD
import excel "$input_pnadcdoc\Ocupacao_COD.xls", sheet("Estrutura COD") cellrange(A3:E617) firstrow clear

* clean data
cap gen titulo = Denominação 

* take out accents and double space
gen normalized_string = ustrto(ustrnormalize(titulo, "nfd"), "ascii", 2)
replace titulo = normalized_string
drop normalized_string

replace titulo = lower(titulo)
replace titulo = proper(titulo)
cap gen cod_codagr = Subgrupoprincipal
cap tostring cod_codagr, replace
keep if cod_codagr !=""
sort cod_codagr
keep cod_codagr titulo


gen new_name = ""
destring cod_codagr, gen(codnumeric)
replace new_name  = "Forças armadas e militatres" if inrange(codnumeric, 1, 5)
replace new_name  = "Administração pública" if inrange(codnumeric, 11, 11)
replace new_name  = "Dirigentes e gerentes" if inrange(codnumeric, 12, 14)

replace new_name  = "Profissionais em ciências e engenharia" if codnumeric == 21 // Profissionais Das Ciencias E Da Engenharia
replace new_name  = "Profissionais em ciências e engenharia" if codnumeric == 31 // Profissionais De Nivel Medio Das Ciencias E Da Engenharia

replace new_name  = "Profissionais em saúde" if codnumeric == 22 // Profissionais Da Saude
replace new_name  = "Profissionais em saúde" if codnumeric == 32 // Profissionais De Nivel Medio Da Saude E Afins

replace new_name  = "Profissionais em administração" if codnumeric == 24 // Especialistas Em Organizacao Da Administracao Publica E De Empresas
replace new_name  = "Profissionais em administração" if codnumeric == 33 // Profissionais De Nivel Medio Em Operacoes Financeiras E Administrativas

replace new_name  = "Profissionais em tecnologias da informação" if codnumeric == 25 // Profissionais De Tecnologias Da Informacao E Comunicacoes
replace new_name  = "Profissionais em tecnologias da informação" if codnumeric == 35 // Tecnicos De Nivel Medio Da Tecnologia Da Informacao E Das Comunicacoes

replace new_name  = "Profissionais em direito, ciências sociais e culturais" if codnumeric == 26 // Profissionais  Em Direito, Em Ciencias Sociais E Culturais
replace new_name  = "Profissionais em direito, ciências sociais e culturais" if codnumeric == 41 // Escriturarios

replace new_name  = "Apoio administrativo" if inrange(codnumeric, 42, 44)

replace new_name  = "Serviços pessoais, cuidado e proteção" if codnumeric == 51 // Trabalhadores Dos Servicos Pessoais
replace new_name  = "Serviços pessoais, cuidado e proteção" if codnumeric == 53 // Trabalhadores Dos Cuidados Pessoais
replace new_name  = "Serviços pessoais, cuidado e proteção" if codnumeric == 54 // Trabalhadores Dos Servicos De Protecao E Seguranca

replace new_name  = "Vendedores" if codnumeric == 52 // Vendedores

replace new_name  = "Agricultura, pecuária e produção florestal" if codnumeric == 61 // Agricultores E Trabalhadores Qualificados Da Agropecuaria
replace new_name  = "Agricultura, pecuária e produção florestal" if codnumeric == 62 // Trabalhadores Florestais Qualificados, Pescadores E Cacadores

replace new_name  = "Operários da construção e metalurgia qualificados" if codnumeric == 71 // Trabalhadores Qualificados E Operarios Da Metalurgia, Da Construcao Mecanica
replace new_name  = "Operários da construção e metalurgia qualificados" if codnumeric == 72 // Trabalhadores Qualificados E Operarios Da Construcao Exclusive Eletricistas
replace new_name  = "Operários da construção e metalurgia qualificados" if codnumeric == 73 // Artesaos E Operarios Das Artes Graficas
replace new_name  = "Operários da construção e metalurgia qualificados" if codnumeric == 74 // Trabalhadores Especializados Em Eletricidade E Eletronica

replace new_name  = "Trabalhadores domésticos" if codnumeric == 91 // Trabalhadores Domesticos E Outros Trabalhadores De Limpeza De Interior De Edificios
replace new_name  = "Operários da construção e metalurgia qualificados" if codnumeric == 61 // Agricultores E Trabalhadores Qualificados Da Agropecuaria


replace new_name  = "Profissionais de nível médio" if inrange(codnumeric, 31, 35)
replace new_name  = "Profissionais de nível médio" if inrange(codnumeric, 31, 35)
replace new_name  = "Profissionais de nível médio" if inrange(codnumeric, 31, 35)


* keep only relevant variables
replace titulo = new_name
cap drop cod_cod2dig
gen  cod_cod2dig = cod_codagr
sort cod_codagr titulo cod_cod2dig
keep cod_codagr titulo cod_cod2dig

* save in the output directory
compress
save "$output_dir\cod_cod2dig.dta", replace