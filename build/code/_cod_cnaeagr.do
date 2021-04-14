//////////////////////////////////////////////
//	
//	Descricao de codigos de atividades (agregado)
//	
//////////////////////////////////////////////

* call data Atividade_CNAE_Domiciliar_2_0
import excel "$input_pnadcdoc\Atividade_CNAE_Domiciliar_2_0.xls", sheet("Estrutura CNAE Domiciliar 2.0") cellrange(A3:E335) firstrow clear

* clean data
cap gen titulo = Denominação 

* take out accents and double space
gen normalized_string = ustrto(ustrnormalize(titulo, "nfd"), "ascii", 2)
replace titulo = normalized_string
drop normalized_string
replace titulo = lower(titulo)
replace titulo = proper(titulo)
cap gen cod_cnaeagr = Divisão
cap tostring cod_cnaeagr, replace
keep if cod_cnaeagr !=""
sort cod_cnaeagr
keep cod_cnaeagr titulo

gen new_name = ""
destring cod_cnaeagr, gen(codnumeric) 

replace new_name = "Outros"  if codnumeric == 00	
replace new_name = "Agricultura"  if codnumeric == 01	
replace new_name = "Produção florestal"  if codnumeric == 02	
replace new_name = "Pesca e aquicultura"  if codnumeric == 03	
replace new_name = "Extração de carvão, petróleo e gás"  if codnumeric == 05	
replace new_name = "Extração de carvão, petróleo e gás"  if codnumeric == 06	
replace new_name = "Extração mineral"  if codnumeric == 07	
replace new_name = "Extração mineral"  if codnumeric == 08	
replace new_name = "Extração mineral"  if codnumeric == 09	
replace new_name = "Alimentos, bebidas e fumo"  if codnumeric == 10	
replace new_name = "Alimentos, bebidas e fumo"  if codnumeric == 11	
replace new_name = "Alimentos, bebidas e fumo"  if codnumeric == 12	
replace new_name = "Têxtil, vestuário, couro e calçados"  if codnumeric == 13	
replace new_name = "Têxtil, vestuário, couro e calçados"  if codnumeric == 14	
replace new_name = "Têxtil, vestuário, couro e calçados"  if codnumeric == 15	
replace new_name = "Madeira, celulose e papel"  if codnumeric == 16	
replace new_name = "Madeira, celulose e papel"  if codnumeric == 17	
replace new_name = "Madeira, celulose e papel"  if codnumeric == 18	
replace new_name = "Químicos, derivados de petróleo e farmacêuticos"  if codnumeric == 19	
replace new_name = "Químicos, derivados de petróleo e farmacêuticos"  if codnumeric == 20	
replace new_name = "Químicos, derivados de petróleo e farmacêuticos"  if codnumeric == 21	
replace new_name = "Borracha e plástico"  if codnumeric == 22	
replace new_name = "Produtos de metal, minerais não-metálicos e metalurgia"  if codnumeric == 23	
replace new_name = "Produtos de metal, minerais não-metálicos e metalurgia"  if codnumeric == 24	
replace new_name = "Produtos de metal, minerais não-metálicos e metalurgia"  if codnumeric == 25	
replace new_name = "Eletrônicos, máquinas e equipamentos"  if codnumeric == 26	
replace new_name = "Eletrônicos, máquinas e equipamentos"  if codnumeric == 27	
replace new_name = "Eletrônicos, máquinas e equipamentos"  if codnumeric == 28	
replace new_name = "Automóveis e equipamentos de transporte"  if codnumeric == 29	
replace new_name = "Automóveis e equipamentos de transporte"  if codnumeric == 30	
replace new_name = "Móveis"  if codnumeric == 31	
replace new_name = "Outros"  if codnumeric == 32	
replace new_name = "Eletrônicos, máquinas e equipamentos"  if codnumeric == 33	
replace new_name = "Eletricidade e gás"  if codnumeric == 35	
replace new_name = "Água e esgoto"  if codnumeric == 36	
replace new_name = "Água e esgoto"  if codnumeric == 37	
replace new_name = "Água e esgoto"  if codnumeric == 38	
replace new_name = "Água e esgoto"  if codnumeric == 39	
replace new_name = "Construção"  if codnumeric == 41	
replace new_name = "Construção"  if codnumeric == 42	
replace new_name = "Construção"  if codnumeric == 43	
replace new_name = "Comércio"  if codnumeric == 45	
replace new_name = "Comércio"  if codnumeric == 48	
replace new_name = "Transporte e correio"  if codnumeric == 49	
replace new_name = "Transporte e correio"  if codnumeric == 50	
replace new_name = "Transporte e correio"  if codnumeric == 51	
replace new_name = "Transporte e correio"  if codnumeric == 52	
replace new_name = "Transporte e correio"  if codnumeric == 53	
replace new_name = "Serviços de alojamento e alimentação"  if codnumeric == 55	
replace new_name = "Serviços de alojamento e alimentação"  if codnumeric == 56	
replace new_name = "Serviços de informação e comunicação"  if codnumeric == 58	
replace new_name = "Serviços de informação e comunicação"  if codnumeric == 59	
replace new_name = "Serviços de informação e comunicação"  if codnumeric == 60	
replace new_name = "Serviços de informação e comunicação"  if codnumeric == 61	
replace new_name = "Serviços de informação e comunicação"  if codnumeric == 62	
replace new_name = "Serviços de informação e comunicação"  if codnumeric == 63	
replace new_name = "Serviços financeiros e de seguros"  if codnumeric == 64	
replace new_name = "Serviços financeiros e de seguros"  if codnumeric == 65	
replace new_name = "Serviços financeiros e de seguros"  if codnumeric == 66	
replace new_name = "Atividades profissionais, científicas e técnicas"  if codnumeric == 68	
replace new_name = "Atividades profissionais, científicas e técnicas"  if codnumeric == 69	
replace new_name = "Atividades profissionais, científicas e técnicas"  if codnumeric == 70	
replace new_name = "Atividades profissionais, científicas e técnicas"  if codnumeric == 71	
replace new_name = "Atividades profissionais, científicas e técnicas"  if codnumeric == 72	
replace new_name = "Atividades profissionais, científicas e técnicas"  if codnumeric == 73	
replace new_name = "Atividades profissionais, científicas e técnicas"  if codnumeric == 74	
replace new_name = "Atividades profissionais, científicas e técnicas"  if codnumeric == 75	
replace new_name = "Atividades administrativas e serviços complementares"  if codnumeric == 77	
replace new_name = "Atividades administrativas e serviços complementares"  if codnumeric == 78	
replace new_name = "Atividades administrativas e serviços complementares"  if codnumeric == 79	
replace new_name = "Atividades administrativas e serviços complementares"  if codnumeric == 80	
replace new_name = "Atividades administrativas e serviços complementares"  if codnumeric == 81	
replace new_name = "Atividades administrativas e serviços complementares"  if codnumeric == 82	
replace new_name = "Administração pública, defesa e seguridade social"  if codnumeric == 84	
replace new_name = "Educação"  if codnumeric == 85	
replace new_name = "Saúde e assistência social"  if codnumeric == 86	
replace new_name = "Saúde e assistência social"  if codnumeric == 87	
replace new_name = "Saúde e assistência social"  if codnumeric == 88	
replace new_name = "Artes, cultura, esportes e recreação"  if codnumeric == 90	
replace new_name = "Artes, cultura, esportes e recreação"  if codnumeric == 91	
replace new_name = "Artes, cultura, esportes e recreação"  if codnumeric == 92	
replace new_name = "Artes, cultura, esportes e recreação"  if codnumeric == 93	
replace new_name = "Serviços de organizações religiosas, sindicais e patronais"  if codnumeric == 94	
replace new_name = "Juntar com Serviços de informação e comunicação"  if codnumeric == 95	
replace new_name = "Serviços pessoais (cabelereiros, lavanderias, etc.)"  if codnumeric == 96	
replace new_name = "Serviços domésticos"  if codnumeric == 97	
replace new_name = "Outros"  if codnumeric == 99	

* keep only relevant variables
replace titulo = new_name
sort cod_cnaeagr titulo
keep cod_cnaeagr titulo

* save in the output directory
compress
save "$output_dir\cod_cnaeagr.dta", replace