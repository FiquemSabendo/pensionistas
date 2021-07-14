# Metodologia

Este aplicativo permite a visualização de informações relativas a pensões militares do Governo Federal. 

Os dados utilizados são provenientes do [Portal da Transparência](http://transparencia.gov.br/download-de-dados/servidores). A responsabilidade pelo preenchimento dos dados é do Ministério da Defesa, que envia mensalmente as informações à Controladoria-Geral da União (CGU) para consolidação e disponibilização no formato utilizado no Portal.

O código-fonte da aplicação e as consultas realizadas na base de dados podem ser acessadas [no GitHub](https://github.com/FIquemSabendo/pensionistas).

## Transformações aplicadas nos dados

### Tabela com valores resumidos

Para as ferramentas [`Análises de ranking`](https://fabdev.shinyapps.io/pensionistas_militares/#section-an%C3%A1lises-de-ranking) e [`Gráfico de análise de série temporal`](https://fabdev.shinyapps.io/pensionistas_militares/#section-gr%C3%A1fico-de-an%C3%A1lise-de-s%C3%A9rie-temporal), foi elaborada uma versão sintética dos dados disponibilizados no portal da transparência. Essa versão resumida contém:

- Todas as combinações de tipo de beneficiário (isto é, o vínculo entre beneficiário e servidor que instituiu a pensão), órgão e cargo do servidor instituidor, e quantidade de vínculos mantidos pelo pensionista, por mês do pagamento.
- Estatísticas básicas dos valores pagos pela União a pensionistas de cada uma dessas combinações, incluindo:
  - Número de pensionistas que se encaixam em cada combinação;
  - Total pago a pensionistas dentro de cada combinação (bruto e líquido);
  - Máximo valor pago a um pensionista dentro de cada combinação (bruto e líquido);
  - Data da pensão mais antiga dentro de cada combinação;

Nesse caso, pensionistas com mais de uma pensão militar tiveram apenas a sua remuneração consolidada considerada, sendo separados dos demais por meio da variável `NUMERO DE VINCULOS`.

A planilha com os dados resumidos está disponível para consulta e download em formato CSV por meio [deste link](https://raw.githubusercontent.com/FiquemSabendo/pensionistas/master/202102-202001_Pensionistas_DEFESA_FBarbalhoApp.csv).

### Tabela detalhada por pensionista

A ferramenta [`Dados para o último mês disponível`](https://fabdev.shinyapps.io/pensionistas_militares/#section-dados-para-o-%C3%BAltimo-m%C3%AAs-dispon%C3%ADvel) possibilita a busca discriminada por nome do pensionista ou do instituidor da pensão. Para isso, utiliza um subconjunto das colunas geradas pelo cruzamento das tabelas `Cadastro.csv` e `Remuneracao.csv` mais recentes disponibilizadas no Portal da Transparência para os pensionistas do Ministério da Defesa.

Para garantir a correspondência entre os dados de cadastro e de remuneração mesmo em casos de pensionistas homônimos ou quando há restrição de dados pessoais (por exemplo, quando o pensionista é menor de 16 anos), a coluna de identificação do pensionista no Portal da Transparência (coluna `id_servidor_portal`) é utilizada como chave comum entre as duas tabelas.

Para lidar com os casos em que há mais de um registro para o mesmo pensionista na tabela de cadastro (o pensionista tem múltiplo vínculos), foi adicionada uma coluna específica na ferramenta que indica a existência de várias pensões. Nesses casos, **a remuneração _total_ do pensionista é indicada em cada uma das linhas, não devendo ser somada entre diferentes linhas**.

Uma versão da base de dados dos pensionistas do Governo Federal em um arquivo único, incluindo as pensões civis e toda a série histórica publicada no Portal da Transparência, está disponível para download [neste link](https://drive.google.com/file/d/1e5W6fGJ5WsM_fxI18QK9JiHH-3F4sudq/view?usp=sharing).

## A história da divulgação das pensões militares e do aplicativo

A divulgação dos valores pagos a pensionistas das Forças Armadas ocorreu um ano e meio após decisão do Tribunal de Contas da União determinando a abertura dos dados das pensões civis e militares pelo Governo Federal. O tribunal acolheu denúncia da [Fiquem Sabendo](https://fiquemsabendo.com.br/), agência de dados especializada na Lei de Acesso à Informação que [desde 2017 vinha tentando obter acesso a esses dados](https://fiquemsabendo.com.br/transparencia/denuncia-fiquem-sabendo-tcu-pensoes-militares/).

Em julho de 2020, a Fiquem Sabendo obteve pela primeira vez a série histórica com 27 anos de pagamentos de pensão a parentes de servidores civis e a dependentes de militares de ex-territórios federais. Na ocasião, foi disponibilizada a primeira versão do aplicativo elaborado pelo cientista de dados [Fernando Barbalho](https://twitter.com/barbalhofernand), utilizando apenas os dados parciais de militares então disponibilizados pelo Ministério da Defesa.

Com a divulgação dos dados completos pela CGU, o aplicativo foi atualizado para refletir os valores repassados mensalmente a todos os pensionistas das Forças Armadas, desde o início da nova série histórica. Também foram adicionadas novas ferramentas para consultar os dados individualizados por pensionista e a seção de metodologia. O trabalho contou com a colaboração técnica de Fernando Barbalho e com a contribuição do [Brasil.io](https://brasil.io/) para o processamento dos dados e infraestrutura.

## Contato

Caso tenha alguma dúvida sobre o funcionamento do aplicativo, entre em contato com os desenvolvedores pelo e-mail [contato@fiquemsabendo.com.br](mailto:contato@fiquemsabendo.com.br).

Caso tenha alguma questão relacionada aos dados das pensões militares, entre em contato diretamente com a Controladoria-Geral da União, responsável pela divulgação nos dados no Portal da Transparência. Para sugestões, dúvidas ou informações, entre em contato com o órgão por meio do sistema [Fala.BR](https://falabr.cgu.gov.br/).

## Compartilhando as informações do aplicativo

A Fiquem Sabendo é uma agência de dados independente e especializada na Lei de Acesso à Informação (LAI). Somos uma associação sem fins lucrativos, apartidária e independente.

Todo o material publicado gratuitamente no aplicativo Don’t LAI to me, pode e deve ser compartilhado! Usamos a licença "Atribuição 4.0 Internacional (CC BY 4.0)", que permite a republicação/adaptação, inclusive para fins comerciais, nas seguintes condições:

*Todas as republicações ou reportagens feitas a partir de dados/documentos liberados pela nossa equipe devem trazer o nome da Fiquem Sabendo no início do texto, com crédito para: “Fiquem Sabendo, agência de dados especializada na Lei de Acesso à Informação (LAI)”.*

*Toda republicação deve conter link para o aplicativo ou para o [site](https://fiquemsabendo.com.br/) da Fiquem Sabendo.*

*As postagens no Twitter e outras redes sociais sobre as reportagens republicadas devem conter menção ao perfil @_fiquemsabendo.*

Para mais informações: [contato@fiquemsabendo.com.br](mailto:contato@fiquemsabendo.com.br).
