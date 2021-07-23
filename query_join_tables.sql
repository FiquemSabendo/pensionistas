CREATE MATERIALIZED VIEW observacoes_unique AS
  select
    ano,
    mes,
    id_servidor_portal,
    sistema_origem,
    string_agg(distinct observacao, ';' order by observacao) as observacoes
  from pensionista_observacao
  group by ano, mes, id_servidor_portal, sistema_origem;
-- SELECT 4771684
-- Time: 167061.487 ms (02:47.061)

CREATE INDEX obs_u_key ON observacoes_unique (ano, mes, id_servidor_portal, sistema_origem);
---- Time: 17936.455 ms (00:17.936)

CREATE MATERIALIZED VIEW cadastro_unique AS
  select
    ano,
    mes,
    id_servidor_portal,
    sistema_origem,
    string_agg(distinct cod_org_lotacao_instituidor_pensao::varchar, ';' ORDER BY cod_org_lotacao_instituidor_pensao::varchar asc) as cod_org_lotacao_instituidor_pensao,
    string_agg(distinct cod_orgsup_lotacao_instituidor_pensao::varchar, ';' ORDER BY cod_orgsup_lotacao_instituidor_pensao::varchar asc) as cod_orgsup_lotacao_instituidor_pensao,
    string_agg(distinct cod_tipo_pensao::varchar, ';' ORDER BY cod_tipo_pensao::varchar asc) as cod_tipo_pensao,
    string_agg(distinct cod_tipo_vinculo::varchar, ';' ORDER BY cod_tipo_vinculo::varchar asc) as cod_tipo_vinculo,
    string_agg(distinct cod_uorg_lotacao_instituidor_pensao::varchar, ';' ORDER BY cod_uorg_lotacao_instituidor_pensao::varchar asc) as cod_uorg_lotacao_instituidor_pensao,
    string_agg(distinct cpf::varchar, ';' ORDER BY cpf::varchar asc) as cpf,
    string_agg(distinct cpf_instituidor_pensao::varchar, ';' ORDER BY cpf_instituidor_pensao::varchar asc) as cpf_instituidor_pensao,
    string_agg(distinct cpf_representante_legal::varchar, ';' ORDER BY cpf_representante_legal::varchar asc) as cpf_representante_legal,
    string_agg(distinct data_diploma_ingresso_servicopublico_instituidor_pensao::varchar, ';' ORDER BY data_diploma_ingresso_servicopublico_instituidor_pensao::varchar asc) as data_diploma_ingresso_servicopublico_instituidor_pensao,
    string_agg(distinct data_ingresso_cargofuncao_instituidor_pensao::varchar, ';' ORDER BY data_ingresso_cargofuncao_instituidor_pensao::varchar asc) as data_ingresso_cargofuncao_instituidor_pensao,
    string_agg(distinct data_ingresso_orgao_instituidor_pensao::varchar, ';' ORDER BY data_ingresso_orgao_instituidor_pensao::varchar asc) as data_ingresso_orgao_instituidor_pensao,
    min(data_inicio_pensao) as data_inicio_pensao,
    string_agg(distinct data_nomeacao_cargofuncao_instituidor_pensao::varchar, ';' ORDER BY data_nomeacao_cargofuncao_instituidor_pensao::varchar asc) as data_nomeacao_cargofuncao_instituidor_pensao,
    string_agg(distinct descricao_cargo_instituidor_pensao::varchar, ';' ORDER BY descricao_cargo_instituidor_pensao::varchar asc) as descricao_cargo_instituidor_pensao,
    string_agg(distinct diploma_ingresso_cargofuncao_instituidor_pensao::varchar, ';' ORDER BY diploma_ingresso_cargofuncao_instituidor_pensao::varchar asc) as diploma_ingresso_cargofuncao_instituidor_pensao,
    string_agg(distinct diploma_ingresso_orgao_instituidor_pensao::varchar, ';' ORDER BY diploma_ingresso_orgao_instituidor_pensao::varchar asc) as diploma_ingresso_orgao_instituidor_pensao,
    string_agg(distinct diploma_ingresso_servicopublico_instituidor_pensao::varchar, ';' ORDER BY diploma_ingresso_servicopublico_instituidor_pensao::varchar asc) as diploma_ingresso_servicopublico_instituidor_pensao,
    string_agg(distinct documento_ingresso_servicopublico_instituidor_pensao::varchar, ';' ORDER BY documento_ingresso_servicopublico_instituidor_pensao::varchar asc) as documento_ingresso_servicopublico_instituidor_pensao,
    string_agg(distinct jornada_de_trabalho_instituidor_pensao::varchar, ';' ORDER BY jornada_de_trabalho_instituidor_pensao::varchar asc) as jornada_de_trabalho_instituidor_pensao,
    string_agg(distinct matricula::varchar, ';' ORDER BY matricula::varchar asc) as matricula,
    string_agg(distinct menor_16::varchar, ';' ORDER BY menor_16::varchar asc) as menor_16,
    string_agg(distinct nome::varchar, ';' ORDER BY nome::varchar asc) as nome,
    string_agg(distinct nome_instituidor_pensao::varchar, ';' ORDER BY nome_instituidor_pensao::varchar asc) as nome_instituidor_pensao,
    string_agg(distinct nome_representante_legal::varchar, ';' ORDER BY nome_representante_legal::varchar asc) as nome_representante_legal,
    string_agg(distinct org_lotacao_instituidor_pensao::varchar, ';' ORDER BY org_lotacao_instituidor_pensao::varchar asc) as org_lotacao_instituidor_pensao,
    string_agg(distinct orgsup_lotacao_instituidor_pensao::varchar, ';' ORDER BY orgsup_lotacao_instituidor_pensao::varchar asc) as orgsup_lotacao_instituidor_pensao,
    string_agg(distinct regime_juridico_instituidor_pensao::varchar, ';' ORDER BY regime_juridico_instituidor_pensao::varchar asc) as regime_juridico_instituidor_pensao,
    string_agg(distinct situacao_vinculo::varchar, ';' ORDER BY situacao_vinculo::varchar asc) as situacao_vinculo,
    string_agg(distinct tipo_pensao::varchar, ';' ORDER BY tipo_pensao::varchar asc) as tipo_pensao,
    string_agg(distinct tipo_vinculo::varchar, ';' ORDER BY tipo_vinculo::varchar asc) as tipo_vinculo,
    string_agg(distinct uorg_lotacao_instituidor_pensao::varchar, ';' ORDER BY uorg_lotacao_instituidor_pensao::varchar asc) as uorg_lotacao_instituidor_pensao
  from pensionista_cadastro
  group by ano, mes, id_servidor_portal, sistema_origem;
-- SELECT 8048979
-- Time: 521938.335 ms (08:41.938)

CREATE INDEX cadastro_u_key ON cadastro_unique (ano, mes, id_servidor_portal, sistema_origem);
-- Time: 120077.119 ms (02:00.077)

CREATE INDEX remuneracao_u_key ON pensionista_remuneracao (ano, mes, id_servidor_portal, sistema_origem);
-- Time: 40573.196 ms (00:40.573)

CREATE MATERIALIZED VIEW pensionista_final AS
  select
    r.*,
    o.observacoes,
    (case when cod_org_lotacao_instituidor_pensao like '%;%' then -999 else cod_org_lotacao_instituidor_pensao::bigint end) as cod_org_lotacao_instituidor_pensao,
    (case when cod_orgsup_lotacao_instituidor_pensao like '%;%' then -999 else cod_orgsup_lotacao_instituidor_pensao::bigint end) as cod_orgsup_lotacao_instituidor_pensao,
    (case when cod_tipo_pensao like '%;%' then -999 else cod_tipo_pensao::bigint end) as cod_tipo_pensao,
    (case when cod_tipo_vinculo like '%;%' then -999 else cod_tipo_vinculo::bigint end) as cod_tipo_vinculo,
    (case when cod_uorg_lotacao_instituidor_pensao like '%;%' then -999 else cod_uorg_lotacao_instituidor_pensao::bigint end) as cod_uorg_lotacao_instituidor_pensao,
    cpf_instituidor_pensao,
    cpf_representante_legal,
    (case when data_diploma_ingresso_servicopublico_instituidor_pensao like '%;%' then Null else data_diploma_ingresso_servicopublico_instituidor_pensao::date end) as data_diploma_ingresso_servicopublico_instituidor_pensao,
    (case when data_ingresso_cargofuncao_instituidor_pensao like '%;%' then Null else data_ingresso_cargofuncao_instituidor_pensao::date end) as data_ingresso_cargofuncao_instituidor_pensao,
    (case when data_ingresso_orgao_instituidor_pensao like '%;%' then Null else data_ingresso_orgao_instituidor_pensao::date end) as data_ingresso_orgao_instituidor_pensao,
    data_inicio_pensao,
    (case when data_nomeacao_cargofuncao_instituidor_pensao like '%;%' then Null else data_nomeacao_cargofuncao_instituidor_pensao::date end) as data_nomeacao_cargofuncao_instituidor_pensao,
    descricao_cargo_instituidor_pensao,
    diploma_ingresso_cargofuncao_instituidor_pensao,
    diploma_ingresso_orgao_instituidor_pensao,
    diploma_ingresso_servicopublico_instituidor_pensao,
    documento_ingresso_servicopublico_instituidor_pensao,
    jornada_de_trabalho_instituidor_pensao,
    matricula,
    nome_instituidor_pensao,
    nome_representante_legal,
    org_lotacao_instituidor_pensao,
    orgsup_lotacao_instituidor_pensao,
    regime_juridico_instituidor_pensao,
    situacao_vinculo,
    tipo_pensao,
    tipo_vinculo,
    uorg_lotacao_instituidor_pensao
  from cadastro_unique as c
  full join pensionista_remuneracao as r on
    c.ano = r.ano
    and c.mes = r.mes
    and c.id_servidor_portal = r.id_servidor_portal
    and c.sistema_origem = r.sistema_origem
  full join observacoes_unique as o on
    c.ano = o.ano
    and c.mes = o.mes
    and c.id_servidor_portal = o.id_servidor_portal
    and c.sistema_origem = o.sistema_origem;
-- SELECT 8048979
-- Time: 507343.027 ms (08:27.343)
