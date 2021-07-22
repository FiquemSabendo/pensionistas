/*
GERAÇÃO DE PLANILHA COM DADOS INDIVIDUALIZADOS DE PENSÕES DO GOVERNO FEDERAL
(ÚLTIMO MÊS COM DADOS)

Dados obtidos do Portal da Transparência 
(http://transparencia.gov.br/download-de-dados/servidores), 
pré-processados com rotina de leitura em Python 
(https://github.com/turicas/transparencia-gov-br/tree/develop/pensionista)
e carregados em banco de dados PostgreSQL 11.2.

Veja o arquivo README.md para mais informações.
*/
-- Colunas no arquivo final:
--     "Instituidor da Pensão": data de referência do pagamento da pensão
--     "Categori": se a pensão é militar ou civil
--     "Tipo de Beneficiário": relação entre beneficiário e instituidor da 
--     pensão)
--     "Orgão do instituidor": órgão responsável pela pensão
--     "Cargo do instituidor": último cargo ocupado pelo instituidor da pensão
--     "Remuneração bruta": remuneração básica bruta relativa às pensões
--     recebidas pelo beneficiário.
--     "Remuneração líquida": remuneração total recebida pelo beneficiário
--     após descontos obrigatórios e outras remunerações eventuais.
--     "Vários vínculos": indicador sobre a existência de múltiplos vínculos
--     para o beneficiário em um ou mais sistemas de registro de pagamentos
--     do Governo Federal.
select
    nome_instituidor_pensao as "Instituidor da Pensão",
    nome as "Pensionista",
    (
    	case
    	when cadastro.sistema_origem = 'DEFESA'
    	then 'Militar'
    	else 'Civil'
    	end
    ) as "Categoria",
    tipo_pensao as "Tipo de Beneficiário",
    org_lotacao_instituidor_pensao as "Orgão do instituidor",
    descricao_cargo_instituidor_pensao as "Cargo do instituidor",
    remuneracao_basica_bruta_brl as "Remuneração bruta",
    remuneracao_apos_deducoes_obrigatorias_brl as "Remuneração líquida",
    (case when qtd_vinculos > 1 then 'Sim' else 'Não' end) as "Vários vínculos"
from (
    select *
    from pensionista_cadastro
    where
        ano = 2021
        and mes = 2
        and cpf is not null
        and cpf != ''
        and nome_instituidor_pensao is not null
        and nome_instituidor_pensao != ''
) as cadastro
inner join (
    select
    	id_servidor_portal,
    	sistema_origem,
    	remuneracao_basica_bruta_brl,
    	remuneracao_apos_deducoes_obrigatorias_brl
    from pensionista_remuneracao
    where
        ano = 2021
        and mes = 2
) as remuneracao
on
    cadastro.id_servidor_portal = remuneracao.id_servidor_portal
    and cadastro.sistema_origem = remuneracao.sistema_origem
left join (
    select
        id_servidor_portal,
        count(*) as qtd_vinculos
    from pensionista_cadastro
    where
        ano = 2021
        and mes = 2
    group by id_servidor_portal
) as varios_vinculos
on
    cadastro.id_servidor_portal = varios_vinculos.id_servidor_portal
order by "Instituidor da Pensão" asc;