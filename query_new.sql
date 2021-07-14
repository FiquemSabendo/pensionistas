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
--     "TIPO DE BENEFICIARIO" relação entre beneficiário e instituidor da 
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
    concat(r.ano, '-', lpad(r.mes::text, 2, '0'), '-01') as "Data Processamento",
    (case when c.tipo_pensao like '%#%' then 'Vários' else c.tipo_pensao end) as "TIPO DE BENEFICIARIO",
    (case when c.org_lotacao_instituidor_pensao like '%#%' then 'Vários' else c.org_lotacao_instituidor_pensao end) as "ORGAO INSTITUIDOR",
    (case when c.descricao_cargo_instituidor_pensao like '%#%' then 'Vários' else c.descricao_cargo_instituidor_pensao end) as "CARGO DO INSTITUIDOR",
    count(*) as quantidade
    sum(r.remuneracao_basica_bruta_brl) as total_rendimento_bruto,
    max(r.remuneracao_basica_bruta_brl) as max_rendimento_bruto,
    sum(r.remuneracao_apos_deducoes_obrigatorias_brl) as total_rendimento_iquido,
    max(r.remuneracao_apos_deducoes_obrigatorias_brl) as max_rendimento_liquido,
    min(c.data_inicio_pensao)::text as min_data_inicio_pensao,

from (
    -- Tabela de cadastro, com informações sobre o pensionista, o instituidor
    -- e o vínculo que gerou a pensão.
    select
        ano,
        mes,
        id_servidor_portal,
        min(data_inicio_pensao) as data_inicio_pensao,
        string_agg(distinct descricao_cargo_instituidor_pensao::varchar, '#') as descricao_cargo_instituidor_pensao,
        string_agg(distinct tipo_pensao::varchar, '#') as tipo_pensao,
        string_agg(distinct org_lotacao_instituidor_pensao::varchar, '#') as org_lotacao_instituidor_pensao
    from pensionista_cadastro
    where sistema_origem = 'DEFESA'
    group by ano, mes, id_servidor_portal
) as c
right join (
    -- Tabela de remuneração, com os valores brutos e líquidos recebidos em
    -- cada mês.
    select *
    from pensionista_remuneracao
    where sistema_origem = 'DEFESA'
) as r
on
    -- Para conectar as tabelas, são utilizados os campos de ano e mês do
    -- pagamento e o identificador único do beneficiário no Portal da
    -- Transparência.
    c.ano = r.ano
    and c.mes = r.mes
    and c.id_servidor_portal = r.id_servidor_portal
group by
    r.ano,
    r.mes,
    "TIPO DE BENEFICIARIO",
    "ORGAO INSTITUIDOR",
    "CARGO DO INSTITUIDOR"
;