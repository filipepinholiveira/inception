# inception

O arquivo docker-compose.yml é usado pelo Docker Compose para definir e gerenciar vários contêineres Docker em um ambiente multi-conteiner. 
Ele permite que você configure e execute aplicações distribuídas de forma simples, especificando como cada contêiner (ou serviço) deve ser configurado e executado, 
incluindo redes, volumes e dependências entre os contêineres. 

Aqui estão os principais componentes e conceitos que geralmente aparecem no arquivo docker-compose.yml:


Estrutura básica

version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    networks:
      - my-network

  database:
    image: postgres:alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - my-network

networks:
  my-network:

volumes:
  db-data:
Explicação:


version: Define a versão do formato do Docker Compose. A mais comum é 3, mas pode variar dependendo da compatibilidade que você deseja.
services: Define os diferentes serviços ou contêineres que compõem a sua aplicação.
web: Nome do serviço (pode ser qualquer nome).
image: A imagem Docker que será usada para este contêiner. Neste exemplo, estamos usando nginx:latest.
ports: Mapeamento de portas. Neste caso, a porta 8080 da máquina host será mapeada para a porta 80 do contêiner.
volumes: Monta diretórios do host dentro do contêiner. Aqui, estamos mapeando o diretório ./html para o diretório /usr/share/nginx/html no contêiner.
networks: Define as redes em que este serviço está inserido. Serviços na mesma rede podem se comunicar.
database: Um segundo serviço que usa a imagem postgres:alpine.
environment: Define variáveis de ambiente, como usuário e senha do PostgreSQL.
volumes: Monta um volume persistente para armazenar os dados do banco de dados, permitindo que os dados sobrevivam ao reinício do contêiner.
networks: Define redes personalizadas para que os contêineres possam se comunicar.
volumes: Define volumes persistentes que podem ser usados pelos contêineres.
Benefícios do Docker Compose:
Automatiza a configuração de múltiplos contêineres.
Isolamento: Cada serviço roda em seu próprio contêiner.
Escalabilidade: Fácil de escalar serviços com o comando docker-compose up --scale.
Ambientes replicáveis: Facilita a criação de ambientes consistentes para desenvolvimento, teste e produção.





Exemplo pratico:

Aqui estão alguns exemplos de arquivos docker-compose.yml com diferentes configurações, 
dependendo do tipo de aplicação e do que você deseja implementar:

1. Exemplo básico: Aplicação com NGINX e PostgreSQL
Esse exemplo configura um servidor web (NGINX) e um banco de dados (PostgreSQL).

version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    networks:
      - app-network

  database:
    image: postgres:alpine
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - app-network

networks:
  app-network:

volumes:
  db-data:

Esse arquivo define dois serviços:

web: Um servidor NGINX que serve conteúdo da pasta ./html.
database: Um banco de dados PostgreSQL, onde as credenciais são configuradas com variáveis de ambiente.
Ambos os serviços compartilham uma rede chamada app-network para se comunicarem entre si.
O volume db-data garante que os dados do PostgreSQL sejam persistentes mesmo se o contêiner for removido.






2. Exemplo com aplicação Node.js e MongoDB
Esse exemplo é útil para uma aplicação Node.js que se conecta a um banco de dados MongoDB.


version: '3'
services:
  nodeapp:
    image: node:14
    working_dir: /app
    volumes:
      - ./app:/app
    command: npm start
    ports:
      - "3000:3000"
    depends_on:
      - mongo
    networks:
      - app-network

  mongo:
    image: mongo:4.2
    volumes:
      - mongo-data:/data/db
    networks:
      - app-network

networks:
  app-network:

volumes:
  mongo-data:


nodeapp: Um serviço que executa uma aplicação Node.js. O código da aplicação está na pasta local ./app, que é montada no contêiner.
mongo: Um serviço que usa o MongoDB, com armazenamento persistente configurado no volume mongo-data.
depends_on: Isso garante que o serviço mongo seja iniciado antes do nodeapp, pois a aplicação depende do banco de dados.









3. Exemplo de WordPress e MySQL
Esse é um exemplo para rodar o WordPress com um banco de dados MySQL.


version: '3.1'
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8000:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb
    volumes:
      - wordpress-data:/var/www/html
    depends_on:
      - db
    networks:
      - app-network

  db:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - app-network

networks:
  app-network:

volumes:
  wordpress-data:
  db-data:



wordpress: Executa a última versão do WordPress. Conecta-se ao banco de dados MySQL, cujas credenciais são passadas como variáveis de ambiente.
db: Um banco de dados MySQL que armazena os dados da aplicação WordPress.
Usa a rede app-network para permitir a comunicação entre os serviços.
Os volumes wordpress-data e db-data garantem que os dados sejam persistentes.
4. Exemplo com Redis e aplicação Python Flask
Esse exemplo mostra como rodar uma aplicação Flask (Python) que se conecta a um cache Redis.





version: '3'
services:
  flask-app:
    build: ./flask-app
    ports:
      - "5000:5000"
    volumes:
      - ./flask-app:/app
    depends_on:
      - redis
    networks:
      - app-network

  redis:
    image: redis:alpine
    networks:
      - app-network

networks:
  app-network:



flask-app: Define um serviço que constrói uma aplicação Flask a partir do diretório ./flask-app. O código da aplicação é montado no contêiner.
redis: Um serviço que usa a imagem Redis para ser usado como cache pela aplicação Flask.
depends_on: Garante que o Redis seja iniciado antes da aplicação Flask.











5. Exemplo com múltiplas instâncias de um serviço (escalabilidade)
Se você quiser escalar um serviço (por exemplo, executar várias instâncias de um servidor web), você pode usar a opção scale.


version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    networks:
      - app-network
    deploy:
      replicas: 3

networks:
  app-network:


O serviço web terá 3 réplicas (ou contêineres) rodando simultaneamente.
A funcionalidade de deploy.replicas é mais utilizada em cenários de orquestração (como Docker Swarm ou Kubernetes), mas pode ser útil em alguns cenários com Docker Compose também.





Comandos úteis:
Iniciar os serviços: docker-compose up
Iniciar os serviços em segundo plano: docker-compose up -d
Escalar um serviço: docker-compose up --scale <service>=<number>
Parar os serviços: docker-compose down



docs.docker.com

