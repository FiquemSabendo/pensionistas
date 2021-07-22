/*
GERAÇÃO DE PLANILHA COM DADOS RESUMIDOS DE PENSÕES MILITARES

Dados obtidos do Portal da Transparência 
(http://transparencia.gov.br/download-de-dados/servidores), 
pré-processados com rotina de leitura em Python 
(https://github.com/turicas/transparencia-gov-br/tree/develop/pensionista)
e carregados em banco de dados PostgreSQL 11.2.

Veja o arquivo README.md para mais informações.
*/
-- Colunas no arquivo final:
--     "Data Processamento": data de referência do pagamento da pensão
--     "CATEGORIA DA PENSAO": se a pensão é militar ou civil
--     "TIPO DE BENEFICIARIO": relação entre beneficiário e instituidor da 
--     pensão)
--     "ORGAO INSTITUIDOR": órgão responsável pela pensão
--     "CARGO DO INSTITUIDOR": último cargo ocupado pelo instituidor da pensão
--     "quantidade": indicador sobre a existência de um vínculo ou de múltiplos
--     vínculos.
--     "total_rendimento_bruto": soma de rendimentos brutos devidos aos
--     pensionistas com as mesmas características
--     "max_rendimento_bruto": maior rendimento bruto devido a um
--     pensionista com as características listadas
--     "total_rendimento_liquido: soma de rendimentos líquidos pagos aos
--     pensionistas com as mesmas características
--     "max_rendimento_liquido": maior rendimento bruto pago a um
--     pensionista com as características listadas
--     "min_data_inicio_pensao": data de instituição da pensão mais antiga
--     de um pensionista com as características listadas.
select
    concat(ano, '-', lpad(mes::text, 2, '0'), '-01') as "Data Processamento",
    (case when sistema_origem = 'DEFESA' then 'Militar' else 'Civil' end) as "CATEGORIA DA PENSAO",
    (case when tipo_pensao like '%;%' then 'Vários' else tipo_pensao end) as "TIPO DE BENEFICIARIO",
    (case when org_lotacao_instituidor_pensao like '%;%' then 'Vários' else org_lotacao_instituidor_pensao end) as "ORGAO INSTITUIDOR",
    (case when descricao_cargo_instituidor_pensao like '%;%' then 'Vários' else descricao_cargo_instituidor_pensao end) as "CARGO DO INSTITUIDOR",
    sum(remuneracao_basica_bruta_brl) as total_rendimento_bruto,
    max(remuneracao_basica_bruta_brl) as max_rendimento_bruto,
    sum(remuneracao_apos_deducoes_obrigatorias_brl) as total_rendimento_iquido,
    max(remuneracao_apos_deducoes_obrigatorias_brl) as max_rendimento_liquido,
    min(data_inicio_pensao)::text as min_data_inicio_pensao,
    count(*) as quantidade
-- Tabela com informações unificadas de cadastro, remuneração e observações
from pensionista_final
group by ano, mes, "CATEGORIA DA PENSAO", "TIPO DE BENEFICIARIO", "ORGAO INSTITUIDOR", "CARGO DO INSTITUIDOR";