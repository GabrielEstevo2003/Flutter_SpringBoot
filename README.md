Esta é uma aplicação Full Stack onde o FrontEnd é composto pelo Flutter com a linguagem Dart e o BackEnd é feito pelo Spring Boot. A persistência de dados é salva no MongoDB.
Ela possui uma entidade chamada Agenda, onde é possivel criar, atualizar, listar ou deletar registros.
Os campos de cidade, bairro e estado são preenchidos automaticamente quando o Cep é digitado, pois este Cep é enviado à API do ViaCep, onde é retornado os outros atributos.

O FrontEnd se conecta ao BackEnd através da URL "http://localhost:8080/agenda", com o Cross Origin permitindo qualquer requisição.

Para rodar, é necessário que o BackEnd esteja rodando junto com o Banco de dados e que voçe crie um projeto flutter digitando o seguinte código no terminal: "flutter create nome_do_projeto". Depois que o código Dart estiver implementado, basta digitar "flutter run" no terminal e escolher o google chrome para abrir a página web.
