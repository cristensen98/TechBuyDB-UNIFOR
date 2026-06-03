# 🛒 TechBuy - Banco de Dados para E-Commerce

Este repositório contém o projeto de banco de dados relacional completo desenvolvido para a **TechBuy**, uma loja virtual de eletrônicos e informática.---

## 📂 Estrutura do Repositório

O projeto está organizado com os seguintes arquivos:

### 🗺️ Modelagem e Diagramas
*   `DER.pdf`: Diagrama Entidade-Relacionamento (DER) completo com entidades, chaves, relacionamentos e cardinalidades.
*   `modelo_logico.pdf`: Documento com o Modelo Lógico Relacional detalhado, dicionário de dados de cada tabela e justificativas da normalização (1FN, 2FN e 3FN).

### 💻 Scripts SQL
*   `script_ddl.sql`: Comandos DDL para criação das tabelas, chaves primárias (PK), estrangeiras (FK) e índices no banco de dados.
*   `insert_dados.sql`: Comandos DML para inserção de dados fictícios para fins de testes (5 clientes, 5 categorias, 7 produtos e 5 pedidos).
*   `consultas.sql`: Contém as 5 consultas SQL exigidas, detalhadamente comentadas e explicadas.

### 📝 Relatórios
*   `Relatório.pdf`: Relatório com a descrição do escopo do problema, mapeamento de cardinalidades e as explicações estruturadas das consultas.

---

## 🛠️ Tecnologias e Bibliotecas Utilizadas
- **SGBD Utilizado**: SQLite (Padrão ANSI SQL compatível com PostgreSQL, MySQL e SQL Server).
- **pandas**: Biblioteca utilizada no script de verificação automática para executar as queries e formatar os resultados em tabelas.
- **SQLite Viewer**: Para a visualização das tabelas.

---

## 🧪 Como Executar e Validar os Testes

Se você possuir o Python e o gerenciador de pacotes `uv` ou `pip` instalados, pode rodar o teste de validação automática localmente para ver as tabelas e queries sendo executadas na prática:

1.  Instale as dependências necessárias:
    ```bash
    pip install pandas
    ```
2.  Execute o script de verificação:
    ```bash
    python test_queries.py
    ```

Isso recriará o banco local `techbuy.db`, aplicará a estrutura DDL, carregará os dados e rodará as 5 consultas exibindo as tabelas de resultado no terminal.

---

## ⚙️ Detalhes das 5 Consultas SQL Implementadas
1.  **Consulta 1 (INNER JOIN)**: Histórico completo de pedidos por cliente.
2.  **Consulta 2 (GROUP BY)**: Agregação financeira de vendas acumuladas e ticket médio por cliente.
3.  **Consulta 3 (LEFT JOIN)**: Relatório de produtos por categoria, garantindo exibição de categorias vazias.
4.  **Consulta 4 (RIGHT JOIN)**: Análise de desempenho de vendas por produto, listando produtos sem vendas.
5.  **Consulta 5 (Complexa)**: Filtro dinâmico de pedidos que faturaram acima da média histórica geral da loja utilizando subqueries.

Desenvolvido por: 
CRISTENSEN UBIRATAN MOREIRA PORPINO - 2425258
 | JOÃO ERICK ALVES CORREIA BARRETO - 2524905
 | RENATO CLEMENTE DE ARAÚJO NETO - 2514949
 | GLEIDISSON LIMA DA SILVA - 2514945
 | MICHELE COSTA ARAUJO - 2524917
