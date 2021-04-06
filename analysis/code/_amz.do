//////////////////////////////////////////////
//	Importancia relativa
//////////////////////////////////////////////

do "$code_dir\_sub_code\_importancia_relativa.do"

//////////////////////////////////////////////////////
//	Rankings de crescimento de absoluto de ocupações
//////////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_sub_code\_rkng_n_ocu_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_rkng_n_ocu_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_rkng_n_ocu_por_ocupacao.do"

//////////////////////////////////////////////////
//	Rankings de taxa de crescimento de ocupações 
//////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_sub_code\_rkng_tx_ocu_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_rkng_tx_ocu_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_rkng_tx_ocu_por_ocupacao.do"

//////////////////////////////////////////////////
//	Rankings de taxa de crescimento de salários 
//////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_sub_code\_rkng_tx_renda_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_rkng_tx_renda_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_rkng_tx_renda_por_ocupacao.do"

//////////////////////////////////////////////////
//	Rankings de taxa de crescimento da massa salarial 
//////////////////////////////////////////////////

//	Por grandes setores econômicos 
* run do file
do "$code_dir\_sub_code\_rkng_tx_massa_por_setor.do"

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_rkng_tx_massa_por_atividade.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_rkng_tx_massa_por_ocupacao.do"

//////////////////////////////////////////////////////
//	Rankings de crescimento de absoluto de ocupações (Agregar CNAE e COD para dois digitos.)
//////////////////////////////////////////////////////

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_rkng_n_ocu_por_atividade_2digitos.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_rkng_n_ocu_por_ocupacao_2digitos.do"

//////////////////////////////////////////////////
//	Rankings de variação da massa salarial (Agregar CNAE e COD para dois digitos.)
//////////////////////////////////////////////////

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_rkng_v_massa_por_atividade_2digitos.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_jovem_rkng_v_massa_por_ocupacao_2digitos.do"