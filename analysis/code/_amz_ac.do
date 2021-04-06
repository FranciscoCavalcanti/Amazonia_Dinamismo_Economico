//////////////////////////////////////////////////////
//	Rankings de crescimento de absoluto de ocupações (Agregar CNAE e COD para dois digitos.)
//////////////////////////////////////////////////////

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_amz_ac_rkng_n_ocu_por_atividade_2digitos.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_amz_ac_rkng_n_ocu_por_ocupacao_2digitos.do"

//////////////////////////////////////////////////
//	Rankings de variação da massa salarial (Agregar CNAE e COD para dois digitos.)
//////////////////////////////////////////////////

//	Por setores atividade econônmica (CNAE)
* run do file
do "$code_dir\_sub_code\_amz_ac_rkng_v_massa_por_atividade_2digitos.do"

//	Por setores tipo de ocupação (COD)
* run do file
do "$code_dir\_sub_code\_amz_ac_rkng_v_massa_por_ocupacao_2digitos.do"