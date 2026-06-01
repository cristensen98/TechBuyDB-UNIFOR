import sqlite3
import pandas as pd

# Este script é responsável por verificar a criação do banco de dados, a inserção dos dados e a execução das consultas SQL definidas.

def run_verification():
    db_file = "techbuy.db"
    
    # 1. conectar ao banco de dados SQLite (ou criar se não existir)
    print("Conectando ao banco de dados SQLite 'techbuy.db'...")
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()
    
    # Habilitar suporte a chaves estrangeiras no SQLite
    cursor.execute("PRAGMA foreign_keys = ON;")
    
    # 2. leer e executar o script DDL para criar as tabelas
    print("Executando Script DDL (script_ddl.sql)...")
    try:
        with open("script_ddl.sql", "r", encoding="utf-8") as f:
            ddl_script = f.read()
        # No SQLite é necessário substituir "INT PRIMARY KEY AUTOINCREMENT" por "INTEGER PRIMARY KEY AUTOINCREMENT" para SQLite, pois o script DDL já deve estar correto para SQLite.
        ddl_script = ddl_script.replace("INT PRIMARY KEY AUTOINCREMENT", "INTEGER PRIMARY KEY AUTOINCREMENT")
        
        # SQLite não suporta RIGHT JOIN, então vamos substituir por LEFT JOIN equivalente no script DDL, se necessário.
        cursor.executescript(ddl_script)
        print("Tabelas criadas com sucesso!")
    except Exception as e:
        print(f"Erro ao criar tabelas: {e}")
        conn.close()
        return

    # 3. Ler e executar o script DML
    print("Executando Script DML (insert_dados.sql)...")
    try:
        with open("insert_dados.sql", "r", encoding="utf-8") as f:
            dml_script = f.read()
        cursor.executescript(dml_script)
        print("Dados de teste inseridos com sucesso!")
    except Exception as e:
        print(f"Erro ao inserir dados: {e}")
        conn.close()
        return

    # 4. Definir as consultas SQL para teste
    queries = {
        "Consulta 1 (INNER JOIN - Pedidos por Cliente)": """
            SELECT 
                c.nome AS cliente_nome, 
                p.id_pedido, 
                p.data_pedido, 
                p.valor_total, 
                p.status
            FROM Pedidos p
            INNER JOIN Clientes c ON p.id_cliente = c.id_cliente
            ORDER BY p.data_pedido DESC;
        """,
        "Consulta 2 (GROUP BY - Faturamento por Cliente)": """
            SELECT 
                c.nome AS cliente_nome, 
                COUNT(p.id_pedido) AS total_pedidos, 
                SUM(p.valor_total) AS faturamento_total,
                ROUND(AVG(p.valor_total), 2) AS ticket_medio_pedidos
            FROM Clientes c
            INNER JOIN Pedidos p ON c.id_cliente = p.id_cliente
            GROUP BY c.id_cliente, c.nome
            ORDER BY faturamento_total DESC;
        """,
        "Consulta 3 (LEFT JOIN - Produtos por Categoria)": """
            SELECT 
                cat.nome AS categoria_nome, 
                COUNT(prod.id_produto) AS total_produtos_cadastrados,
                COALESCE(MAX(prod.preco), 0.00) AS preco_maximo_produto
            FROM Categorias cat
            LEFT JOIN Produtos prod ON cat.id_categoria = prod.id_categoria
            GROUP BY cat.id_categoria, cat.nome
            ORDER BY total_produtos_cadastrados DESC;
        """,
        "Consulta 4 (RIGHT JOIN - Vendas por Produto)": """
            /* Nota: SQLite adicionou suporte a RIGHT JOIN em 3.39.0.
               Caso o SQLite local não suporte, podemos usar LEFT JOIN equivalente.
               Vamos tentar rodar o RIGHT JOIN original. */
            SELECT 
                prod.nome AS produto_nome, 
                prod.preco AS preco_atual,
                COALESCE(SUM(ip.quantidade), 0) AS total_unidades_vendidas
            FROM Itens_Pedido ip
            RIGHT JOIN Produtos prod ON ip.id_produto = prod.id_produto
            GROUP BY prod.id_produto, prod.nome, prod.preco
            ORDER BY total_unidades_vendidas ASC;
        """,
        "Consulta 5 (Consulta Complexa - Pedidos acima da Média)": """
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
        """
    }

    # 5. Executar consultas e exibir resultados
    print("\n" + "="*80)
    print("RESULTADO DAS CONSULTAS SQL")
    print("="*80)
    for name, sql in queries.items():
        print(f"\n>>> {name}")
        try:
            df = pd.read_sql_query(sql, conn)
            print(df.to_string(index=False))
        except Exception as e:
            print(f"Erro ao executar consulta: {e}")
            if "RIGHT JOIN" in name or "RIGHT OUTER JOIN" in sql:
                print("Tentando versão alternativa com LEFT JOIN equivalente para fins de compatibilidade...")
                alternative_sql = """
                    SELECT 
                        prod.nome AS produto_nome, 
                        prod.preco AS preco_atual,
                        COALESCE(SUM(ip.quantidade), 0) AS total_unidades_vendidas
                    FROM Produtos prod
                    LEFT JOIN Itens_Pedido ip ON prod.id_produto = ip.id_produto
                    GROUP BY prod.id_produto, prod.nome, prod.preco
                    ORDER BY total_unidades_vendidas ASC;
                """
                try:
                    df = pd.read_sql_query(alternative_sql, conn)
                    print(df.to_string(index=False))
                except Exception as ex:
                    print(f"Erro na consulta alternativa: {ex}")
        print("-" * 80)
        
    conn.close()

if __name__ == "__main__":
    run_verification()
