-- SCRIPT DML: INSERÇÃO DE DADOS DE TESTE (TECHBUY)

-- 1. Inserir Categorias
INSERT INTO Categorias (nome, descricao) VALUES
('Eletrônicos', 'Dispositivos eletrônicos gerais e Smart TVs'),
('Informática', 'Computadores, notebooks e acessórios de computação'),
('Acessórios', 'Cabos, suportes, carregadores e outros itens menores'),
('Áudio', 'Fones de ouvido, caixas de som e equipamentos de som'),
('Eletrodomésticos', 'Geladeiras, micro-ondas e eletrodomésticos para cozinha'); -- Esta ficará vazia para testar LEFT JOIN

-- 2. Inserir Clientes
INSERT INTO Clientes (nome, email, cpf, telefone, data_cadastro) VALUES
('Carlos Silva', 'carlos.silva@email.com', '12345678901', '(11) 98888-1111', '2026-01-15'),
('Ana Souza', 'ana.souza@email.com', '98765432109', '(21) 97777-2222', '2026-02-10'),
('Bruno Lima', 'bruno.lima@email.com', '45678912300', '(31) 96666-3333', '2026-03-05'),
('Juliana Costa', 'juliana.costa@email.com', '78912345611', '(81) 95555-4444', '2026-04-12'),
('Mariana Rocha', 'mariana.rocha@email.com', '32165498722', '(41) 94444-5555', '2026-05-01'); -- Esta ficará sem pedidos para testes de JOIN

-- 3. Inserir Produtos
INSERT INTO Produtos (nome, descricao, preco, estoque, id_categoria) VALUES
('Smart TV 55"', 'Smart TV LED 55 polegadas 4K Ultra HD', 2800.00, 15, 1),
('Smartphone S23', 'Smartphone com 256GB de armazenamento e tela AMOLED', 4500.00, 20, 1),
('Notebook Pro', 'Notebook Intel Core i7, 16GB RAM, 512GB SSD', 6200.00, 8, 2),
('Mouse Sem Fio', 'Mouse óptico sem fio ergonômico de 1600 DPI', 150.00, 50, 2),
('Teclado Mecânico', 'Teclado mecânico gamer RGB switch azul', 350.00, 30, 2),
('Fone Bluetooth', 'Fone de ouvido com cancelamento de ruído ativo', 299.00, 25, 4),
('Suporte Articulado', 'Suporte de mesa articulado para dois monitores', 120.00, 10, 3); -- Este ficará sem vendas para testar RIGHT JOIN

-- 4. Inserir Pedidos
-- Nota: Inicialmente criamos os pedidos com valor_total zerado e atualizamos com base nos itens
INSERT INTO Pedidos (id_cliente, data_pedido, valor_total, status) VALUES
(1, '2026-05-10 14:30:00', 2950.00, 'Pago'),       -- Pedido 1 (Carlos)
(2, '2026-05-12 09:15:00', 6200.00, 'Pago'),       -- Pedido 2 (Ana)
(1, '2026-05-15 18:45:00', 598.00, 'Enviado'),     -- Pedido 3 (Carlos - 2º pedido)
(3, '2026-05-18 11:20:00', 650.00, 'Pendente'),    -- Pedido 4 (Bruno)
(4, '2026-05-20 16:00:00', 4500.00, 'Pago');       -- Pedido 5 (Juliana)

-- 5. Inserir Itens do Pedido
INSERT INTO Itens_Pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
-- Pedido 1 (Carlos Silva)
(1, 1, 1, 2800.00), -- 1x Smart TV 55"
(1, 4, 1, 150.00),  -- 1x Mouse Sem Fio

-- Pedido 2 (Ana Souza)
(2, 3, 1, 6200.00), -- 1x Notebook Pro

-- Pedido 3 (Carlos Silva)
(3, 6, 2, 299.00),  -- 2x Fone Bluetooth

-- Pedido 4 (Bruno Lima)
(4, 5, 1, 350.00),  -- 1x Teclado Mecânico
(4, 4, 2, 150.00),  -- 2x Mouse Sem Fio

-- Pedido 5 (Juliana Costa)
(5, 2, 1, 4500.00); -- 1x Smartphone S23
