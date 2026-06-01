-- ARQUIVO DE CONSULTAS SQL (TECHBUY)

-- CONSULTA 1: INNER JOIN
-- Objetivo: Listar todos os pedidos realizados no sistema, mostrando o nome do 
-- cliente que realizou a compra, data, valor total e o status.

SELECT 
    c.nome AS cliente_nome, 
    p.id_pedido, 
    p.data_pedido, 
    p.valor_total, 
    p.status
FROM Pedidos p
INNER JOIN Clientes c ON p.id_cliente = c.id_cliente
ORDER BY p.data_pedido DESC;

/*
Explicação:
Esta consulta realiza uma junção interna (INNER JOIN) entre a tabela 'Pedidos' (p)
e a tabela 'Clientes' (c) com base na chave estrangeira 'id_cliente'. 
O INNER JOIN garante que apenas pedidos que possuam um cliente válido correspondente 
(e vice-versa) sejam retornados. A ordenação é decrescente por data para exibir as 
compras mais recentes primeiro.

Resultado Esperado:
Serão retornadas 5 linhas (referentes aos 5 pedidos cadastrados):
1. Juliana Costa - Pedido 5 - Valor: 4500.00 - Status: Pago
2. Bruno Lima - Pedido 4 - Valor: 650.00 - Status: Pendente
3. Carlos Silva - Pedido 3 - Valor: 598.00 - Status: Enviado
4. Ana Souza - Pedido 2 - Valor: 6200.00 - Status: Pago
5. Carlos Silva - Pedido 1 - Valor: 2950.00 - Status: Pago

A cliente "Mariana Rocha" não aparecerá no resultado, pois ela não possui nenhum pedido.
*/


-- CONSULTA 2: GROUP BY (AGREGAÇÃO)
-- Objetivo: Obter métricas de vendas por cliente (número de pedidos, total gasto 
-- e valor médio gasto por pedido).

SELECT 
    c.nome AS cliente_nome, 
    COUNT(p.id_pedido) AS total_pedidos, 
    SUM(p.valor_total) AS faturamento_total,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio_pedidos
FROM Clientes c
INNER JOIN Pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY faturamento_total DESC;

/*
Explicação:
A consulta agrupa as linhas do INNER JOIN por cliente ('id_cliente' e 'nome'). 
Ela utiliza três funções agregadoras do SQL:
- COUNT(): conta o número de pedidos efetuados por cliente.
- SUM(): soma o valor total de todas as compras do cliente.
- AVG(): calcula o valor médio por pedido daquele cliente (arredondado para 2 casas decimais).
A ordenação exibe os clientes que mais geraram faturamento no topo da lista.

Resultado Esperado:
Serão retornadas 4 linhas (clientes com pedidos):
1. Ana Souza - 1 pedido - Total: 6200.00 - Ticket Médio: 6200.00
2. Juliana Costa - 1 pedido - Total: 4500.00 - Ticket Médio: 4500.00
3. Carlos Silva - 2 pedidos - Total: 3548.00 - Ticket Médio: 1774.00
4. Bruno Lima - 1 pedido - Total: 650.00 - Ticket Médio: 650.00

Mariana Rocha não aparece pois não efetuou compras.
*/


-- CONSULTA 3: LEFT JOIN
-- Objetivo: Exibir todas as categorias de produtos cadastradas, com a quantidade 
-- de produtos associados e o maior preço da categoria, mesmo que ela não possua produtos.

SELECT 
    cat.nome AS categoria_nome, 
    COUNT(prod.id_produto) AS total_produtos_cadastrados,
    COALESCE(MAX(prod.preco), 0.00) AS preco_maximo_produto
FROM Categorias cat
LEFT JOIN Produtos prod ON cat.id_categoria = prod.id_categoria
GROUP BY cat.id_categoria, cat.nome
ORDER BY total_produtos_cadastrados DESC;

/*
Explicação:
O LEFT JOIN (ou LEFT OUTER JOIN) garante que todas as categorias da tabela da esquerda 
('Categorias') sejam retornadas, independentemente de haver produtos relacionados 
na tabela da direita ('Produtos'). Usamos COALESCE(MAX(...), 0.00) para que, se não houver 
produto cadastrado (onde o preço máximo seria NULL), seja exibido 0.00.

Resultado Esperado:
Serão retornadas 5 linhas (todas as categorias):
1. Informática - 3 produtos - Preço máximo: 6200.00
2. Eletrônicos - 2 produtos - Preço máximo: 4500.00
3. Acessórios - 1 produto - Preço máximo: 120.00
4. Áudio - 1 produto - Preço máximo: 299.00
5. Eletrodomésticos - 0 produtos - Preço máximo: 0.00  <-- (Categoria sem produtos, mantida pelo LEFT JOIN)
*/


-- CONSULTA 4: RIGHT JOIN
-- Objetivo: Listar todos os produtos e o total de unidades vendidas deles, 
-- garantindo a exibição de produtos que nunca foram vendidos.

SELECT 
    prod.nome AS produto_nome, 
    prod.preco AS preco_atual,
    COALESCE(SUM(ip.quantidade), 0) AS total_unidades_vendidas
FROM Itens_Pedido ip
RIGHT JOIN Produtos prod ON ip.id_produto = prod.id_produto
GROUP BY prod.id_produto, prod.nome, prod.preco
ORDER BY total_unidades_vendidas ASC;

/*
Explicação:
O RIGHT JOIN (ou RIGHT OUTER JOIN) preserva todas as linhas da tabela da direita 
('Produtos'), mesmo se não houver correspondência na tabela da esquerda ('Itens_Pedido').
Isso nos permite verificar o desempenho de vendas de todo o catálogo, identificando 
produtos sem nenhuma venda. COALESCE transforma o valor NULL resultante da soma 
de produtos não vendidos em 0.

Resultado Esperado:
Serão retornadas 7 linhas (todos os produtos cadastrados):
1. Suporte Articulado - Preço: 120.00 - Vendas: 0 <-- (Produto sem vendas, mantido pelo RIGHT JOIN)
2. Smart TV 55" - Preço: 2800.00 - Vendas: 1
3. Smartphone S23 - Preço: 4500.00 - Vendas: 1
4. Notebook Pro - Preço: 6200.00 - Vendas: 1
5. Teclado Mecânico - Preço: 350.00 - Vendas: 1
6. Fone Bluetooth - Preço: 299.00 - Vendas: 2
7. Mouse Sem Fio - Preço: 150.00 - Vendas: 3
*/


-- CONSULTA 5: CONSULTA MAIS COMPLEXA (JOIN + GROUP BY + SUBQUERY)
-- Objetivo: Identificar pedidos que superaram a média geral histórica de faturamento
-- do e-commerce, trazendo o nome do cliente, quantidade de itens diferentes comprados,
-- o total de unidades compradas e a média histórica para fins comparativos.

SELECT 
    p.id_pedido, 
    c.nome AS cliente_nome, 
    p.valor_total,
    COUNT(ip.id_produto) AS itens_diferentes,
    SUM(ip.quantidade) AS total_unidades_compradas,
    (SELECT ROUND(AVG(valor_total), 2) FROM Pedidos) AS media_geral_pedidos
FROM Pedidos p
INNER JOIN Clientes c ON p.id_cliente = c.id_cliente
INNER JOIN Itens_Pedido ip ON p.id_pedido = ip.id_pedido
WHERE p.valor_total > (SELECT AVG(valor_total) FROM Pedidos)
GROUP BY p.id_pedido, c.nome, p.valor_total
ORDER BY p.valor_total DESC;

/*
Explicação:
Esta consulta realiza as seguintes operações simultaneamente:
1. Faz a junção de três tabelas (Pedidos, Clientes e Itens_Pedido) usando INNER JOINs.
2. Utiliza uma Subquery no WHERE para calcular dinamicamente a média de valor de todos 
   os pedidos cadastrados: 'SELECT AVG(valor_total) FROM Pedidos'. Apenas pedidos com valor 
   superior a essa média são processados.
3. Utiliza GROUP BY para consolidar as informações do pedido.
4. Utiliza funções agregadoras (COUNT, SUM) para resumir os itens comprados em cada pedido.
5. Utiliza uma Subquery na lista de projeção (SELECT) para expor a média histórica geral, 
   permitindo comparar visualmente o valor do pedido com a média do e-commerce.

Resultado Esperado:
A média de todos os pedidos é 2.979,60 ((2950 + 6200 + 598 + 650 + 4500) / 5).
Os pedidos com valor superior a 2.979,60 são o Pedido 2 (6200.00) e o Pedido 5 (4500.00).
Portanto, serão retornadas 2 linhas:
1. ID 2 - Ana Souza - Valor: 6200.00 - Itens dif.: 1 - Unidades: 1 - Média Geral: 2979.60
2. ID 5 - Juliana Costa - Valor: 4500.00 - Itens dif.: 1 - Unidades: 1 - Média Geral: 2979.60
*/
