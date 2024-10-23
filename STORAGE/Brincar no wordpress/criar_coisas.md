

BASE DADOS MARIADB

. Conectar ao MariaDB

Para interagir com o banco de dados MariaDB, você pode usar um cliente MySQL/MariaDB ou um plugin de gerenciamento de banco de dados no WordPress.
A. Usando um Cliente MySQL

    Conectar-se ao contêiner MariaDB: Você pode se conectar ao contêiner do MariaDB usando o seguinte comando:

    bash

docker exec -it mariadb mysql -u root -p

Em seguida, insira a senha do root do MariaDB (que deve estar definida no seu arquivo .env ou Dockerfile).

Criar um Banco de Dados e Tabelas: Após conectar-se, você pode criar um banco de dados e tabelas conforme necessário. Por exemplo:

sql

CREATE DATABASE meu_banco_de_dados;
USE meu_banco_de_dados;

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL
);

Inserir Dados: Você pode inserir dados nas tabelas:

sql

    INSERT INTO produtos (nome, preco) VALUES ('Produto 1', 10.00);
    INSERT INTO produtos (nome, preco) VALUES ('Produto 2', 20.00);

B. Usando um Plugin de Gerenciamento de Banco de Dados

Você também pode usar plugins como WP Data Access ou Adminer para gerenciar seu banco de dados diretamente do painel do WordPress.

2. Exibir Dados na Página WordPress

Depois de ter seus dados no banco de dados, você pode exibi-los na página do WordPress de várias maneiras.
A. Usando Código Personalizado

    Criar um Plugin Personalizado: Você pode criar um plugin ou adicionar o código a um tema filho. Aqui está um exemplo simples de como consultar e exibir dados:

    php

    // Adicione isso ao seu arquivo de plugin ou tema

    function mostrar_produtos() {
        global $wpdb;

        // Consulta os produtos
        $produtos = $wpdb->get_results("SELECT * FROM produtos");

        // Exibe os produtos
        foreach ($produtos as $produto) {
            echo '<h2>' . esc_html($produto->nome) . '</h2>';
            echo '<p>Preço: ' . esc_html($produto->preco) . ' €</p>';
        }
    }

    // Adiciona um shortcode para usar no conteúdo do WordPress
    add_shortcode('mostrar_produtos', 'mostrar_produtos');

    Usar o Shortcode: Você pode usar o shortcode [mostrar_produtos] em qualquer página ou post do WordPress para exibir a lista de produtos.

B. Usando Temas ou Plugins de Exibição de Dados

Existem muitos temas e plugins que permitem conectar-se ao banco de dados e exibir dados. Plugins como Custom Post Type UI e Advanced Custom Fields são populares para criar e exibir tipos de conteúdo personalizados.
3. Testar e Depurar

Após a configuração:

    Teste a página do WordPress para garantir que os dados estão sendo exibidos corretamente.
    Verifique os logs do contêiner MariaDB e do WordPress se você encontrar problemas.


---------------------------------------------------------------------------------




PLUGS-IN WORDPRESS

Passo 1: Criar um Plugin Personalizado

    Acesse o Diretório de Plugins do WordPress:
        Navegue até o diretório de plugins do seu WordPress, que geralmente está localizado em:

        css

    /var/www/html/wp-content/plugins/

Crie uma Nova Pasta para o Seu Plugin:

    Crie uma nova pasta para o seu plugin. Por exemplo, meu-plugin-produtos.

Criar um Arquivo Principal do Plugin:

    Dentro da pasta do seu plugin, crie um arquivo PHP. Você pode nomeá-lo como meu-plugin-produtos.php.
    Abra esse arquivo em um editor de texto e adicione o cabeçalho do plugin:

php

    <?php
    /*
    Plugin Name: Meu Plugin de Produtos
    Description: Um plugin para mostrar produtos do banco de dados.
    Version: 1.0
    Author: Seu Nome
    */

Passo 2: Adicionar o Código para Consultar e Exibir Produtos

    Adicionar a Função ao Plugin:
        Após o cabeçalho do plugin, adicione a função para consultar e exibir os produtos, conforme mostrado abaixo:

    php

    function mostrar_produtos() {
        global $wpdb;

        // Consulta os produtos
        $produtos = $wpdb->get_results("SELECT * FROM produtos");

        // Exibe os produtos
        $output = ''; // Inicializa uma variável para armazenar o HTML
        foreach ($produtos as $produto) {
            $output .= '<h2>' . esc_html($produto->nome) . '</h2>';
            $output .= '<p>Preço: ' . esc_html($produto->preco) . ' €</p>';
        }

        return $output; // Retorna o HTML gerado
    }

    // Adiciona um shortcode para usar no conteúdo do WordPress
    add_shortcode('mostrar_produtos', 'mostrar_produtos');

Passo 3: Ativar o Plugin

    Ativar o Plugin no WordPress:
        Acesse o painel de administração do WordPress (normalmente em http://seu_dominio/wp-admin).
        Vá para Plugins > Plugins Instalados.
        Você verá seu plugin "Meu Plugin de Produtos" na lista. Clique em Ativar.

Passo 4: Usar o Shortcode

    Usar o Shortcode na Página ou Post:
        Agora você pode usar o shortcode [mostrar_produtos] em qualquer página ou post do WordPress.
        Por exemplo, crie uma nova página ou edite uma existente e adicione o shortcode no conteúdo:

    plaintext

[mostrar_produtos]

Salvar e Visualizar:

    Salve a página ou post e visualize. Você deve ver a lista de produtos exibida na página.















BRINCAR COM MARIADB


            CRIAR TABELA
            Agora, vamos criar uma tabela dentro do banco de dados empresa. Vamos criar uma tabela simples 
            chamada funcionarios com alguns campos básicos (ID, nome e salário).

            CREATE TABLE funcionarios (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nome VARCHAR(100),
            salario DECIMAL(10, 2)
            );

            Explicação dos tipos de dados:

            INT é usado para armazenar números inteiros.
            AUTO_INCREMENT significa que o valor da coluna será gerado automaticamente pelo MariaDB.
            VARCHAR(100) é uma string de texto com até 100 caracteres.
            DECIMAL(10, 2) é usado para armazenar valores numéricos com precisão decimal (10 dígitos, sendo 2 após a vírgula).



            VISUALIZAR TABELA
            Para visualizar as tabelas no banco de dados atual:
                SHOW TABLES;



            INSERIR DADOS NA TABELA
            Para inserir dados na tabela funcionarios, use o comando INSERT INTO. Por exemplo:
                INSERT INTO funcionarios (nome, salario) 
                VALUES ('João Silva', 3500.00);

            Se você quiser inserir vários registros de uma vez:
                INSERT INTO funcionarios (nome, salario) 
                VALUES ('Maria Oliveira', 4200.50),
                       ('Carlos Santos', 2800.00),
                       ('Ana Costa', 5000.00);


            CONSULTAR DADOS DA TABELA
            Para consultar os dados que você inseriu, use o comando SELECT. Por exemplo, para listar todos os funcionários:
                SELECT * FROM funcionarios;

            Isso vai mostrar todos os registros na tabela funcionarios.

            Para listar apenas determinados campos (por exemplo, apenas o nome e o salário):
                SELECT nome, salario FROM funcionarios;

            

            ATUALIZAR DADOS DA TABELA
            Para atualizar os dados existentes, você pode usar o comando UPDATE. 
            Por exemplo, se você quiser aumentar o salário de um funcionário específico:
                UPDATE funcionarios
                SET salario = 3800.00
                WHERE nome = 'João Silva';


            APAGAR DADOS DA TABELA
            Se você quiser excluir dados, use o comando DELETE. Por exemplo, para excluir o funcionário chamado "Carlos Santos":
                DELETE FROM funcionarios
                WHERE nome = 'Carlos Santos';

            Atenção: O comando DELETE excluirá os dados permanentemente. Se você não usar a cláusula WHERE, todos os dados da tabela serão excluídos.



            ALTERAR ESTRUTURA TAS TABELAS APOS CRIAÇAO
            Você pode modificar a estrutura de uma tabela após ela ter sido criada. Por exemplo, se quiser 
            adicionar uma nova coluna data_admissao à tabela funcionarios:
                ALTER TABLE funcionarios
                ADD COLUMN data_admissao DATE;
                ADD COLUMN idade INT;

            Se você quiser modificar o tipo de dado de uma coluna existente (por exemplo, aumentar o tamanho do nome):
                ALTER TABLE funcionarios
                MODIFY COLUMN nome VARCHAR(255);

            
            APAGAR UMA TABELA
            Se você quiser excluir uma tabela completamente, use o comando DROP TABLE. Isso excluirá a tabela e todos os dados dentro dela.
                DROP TABLE funcionarios;


            COMANDOS UTEIS
                Ver a estrutura de uma tabela: Para ver a estrutura de uma tabela (quais colunas e tipos de dados ela tem), use:
                    DESCRIBE funcionarios;

                Contar o número de registros em uma tabela:
                    SELECT COUNT(*) FROM funcionarios;

                Filtrar resultados com WHERE: Você pode filtrar os resultados da consulta com a cláusula WHERE. 
                Por exemplo, para ver apenas os funcionários com salário superior a 4000:
                    SELECT * FROM funcionarios WHERE salario > 4000;

                Ordenar resultados com ORDER BY: Para ordenar os resultados por uma coluna, use o ORDER BY. 
                Por exemplo, para listar os funcionários por salário em ordem crescente:
                    SELECT * FROM funcionarios ORDER BY salario ASC;
                Para ordem decrescente:
                    SELECT * FROM funcionarios ORDER BY salario DESC;



                Resumo:

                Criar banco de dados: CREATE DATABASE nome_do_banco;
                Criar tabela: CREATE TABLE nome_da_tabela (...);
                Inserir dados: INSERT INTO nome_da_tabela (coluna1, coluna2) VALUES (valor1, valor2);
                Consultar dados: SELECT * FROM nome_da_tabela;
                Atualizar dados: UPDATE nome_da_tabela SET coluna1 = valor1 WHERE condição;
                Deletar dados: DELETE FROM nome_da_tabela WHERE condição;
                Alterar estrutura da tabela: ALTER TABLE nome_da_tabela ADD COLUMN nova_coluna tipo;
                Excluir tabela: DROP TABLE nome_da_tabela;
                Excluir banco de dados: DROP DATABASE nome_do_banco;


        8. Excluir um Banco de Dados (DROP DATABASE)

                Se você quiser excluir um banco de dados inteiro, use o comando DROP DATABASE. 
                Isso removerá o banco de dados e todas as suas tabelas.
                    DROP DATABASE empresa;

