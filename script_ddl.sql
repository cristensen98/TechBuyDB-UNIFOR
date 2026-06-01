-- SCRIPT DDL: CRIAÇÃO DO BANCO DE DADOS TECHBUY (E-COMMERCE)

-- Tabela 1: Categorias
-- Armazena as categorias dos produtos para fins de organização e filtragem.
CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(255)
);

-- Tabela 2: Clientes
-- Armazena as informações dos clientes cadastrados na plataforma.
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    data_cadastro DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- Tabela 3: Produtos
-- Armazena o catálogo de produtos e relaciona-se com Categorias (1:N).
CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categorias (id_categoria) ON DELETE RESTRICT
);

-- Tabela 4: Pedidos
-- Registra as compras efetuadas pelos clientes (1:N).
CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY AUTOINCREMENT,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    FOREIGN KEY (id_cliente) REFERENCES Clientes (id_cliente) ON DELETE RESTRICT
);

-- Tabela 5: Itens_Pedido (Entidade Associativa)
-- Resolve o relacionamento N:N entre Pedidos e Produtos.
-- Armazena a quantidade comprada e o preço histórico do produto no momento do pedido.
CREATE TABLE Itens_Pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos (id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES Produtos (id_produto) ON DELETE RESTRICT
);

-- Índices recomendados para otimização de buscas frequentes (Opcional, mas boa prática)
CREATE INDEX idx_produtos_categoria ON Produtos(id_categoria);
CREATE INDEX idx_pedidos_cliente ON Pedidos(id_cliente);
