# Finança Pessoal - Aplicação de Controle Financeiro

Uma aplicação web completa para gerenciamento de finanças pessoais, com rastreamento de transações, categorização de despesas e receitas, relatórios financeiros e acesso via API externa.

![Logo da Aplicação](generated-icon.png)

## Índice

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Tecnologias](#tecnologias)
- [Requisitos](#requisitos)
- [Instalação](#instalação)
  - [Configuração do Banco de Dados](#configuração-do-banco-de-dados)
  - [Instalação Local](#instalação-local)
  - [Docker](#docker)
  - [Heroku](#heroku)
  - [Railway](#railway)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Guia da API](#guia-da-api)
  - [Autenticação](#autenticação)
  - [Endpoint de Transações](#endpoint-de-transações)
  - [Endpoint de Categorias](#endpoint-de-categorias)
  - [Endpoint da Carteira](#endpoint-da-carteira)
  - [Dashboard e Relatórios](#dashboard-e-relatórios)
- [Exemplos de Uso da API](#exemplos-de-uso-da-api)
- [Dicas de Segurança](#dicas-de-segurança)
- [Contribuição](#contribuição)
- [Licença](#licença)

## Visão Geral

Esta aplicação de finanças pessoais fornece uma plataforma completa para gerenciar suas finanças diárias. Com uma interface intuitiva, você pode acompanhar despesas, receitas, definir categorias personalizadas e visualizar relatórios detalhados sobre seus hábitos financeiros. A aplicação também oferece uma API completa para integração com outros sistemas.

## Funcionalidades

- ✅ Gerenciamento de transações (receitas e despesas)
- ✅ Categorização personalizada
- ✅ Dashboard com resumo financeiro
- ✅ Gráficos e relatórios
- ✅ Múltiplos métodos de pagamento
- ✅ Autenticação segura
- ✅ API REST completa com suporte a tokens
- ✅ Documentação Swagger integrada

## Tecnologias

- **Frontend**: React, TypeScript, TailwindCSS, Shadcn/UI, React Query
- **Backend**: Node.js, Express, TypeScript
- **Banco de Dados**: PostgreSQL (Supabase)
- **ORM**: Drizzle ORM
- **Autenticação**: Passport.js, Tokens JWT
- **Documentação**: Swagger/OpenAPI
- **Validação**: Zod

## Requisitos

- Node.js 18.x ou superior
- PostgreSQL 15.x ou superior (ou uma conta Supabase)
- NPM 9.x ou superior

## Instalação

### Configuração do Banco de Dados

A aplicação utiliza PostgreSQL como banco de dados. Você pode usar um banco de dados PostgreSQL local ou uma instância hospedada como Supabase.

#### Usando Supabase (Recomendado)

1. Crie uma conta em [Supabase](https://supabase.com)
2. Crie um novo projeto
3. Acesse a página do seu projeto
4. Vá para configurações > Database
5. Copie a URI de conexão (Transaction pooler)
6. Substitua `[YOUR-PASSWORD]` com a senha definida para o projeto

### Instalação Local

Siga estes passos para instalar a aplicação em seu ambiente local:

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/financa-pessoal.git
cd financa-pessoal

# Instale as dependências
npm install

# Configure as variáveis de ambiente
cp .env.example .env
# Edite o arquivo .env com suas configurações

# Execute as migrações do banco de dados
npm run migrate

# Inicie o servidor de desenvolvimento
npm run dev
```

Acesse `http://localhost:5000` no seu navegador.

### Docker

Para executar a aplicação usando Docker:

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/financa-pessoal.git
cd financa-pessoal

# Construa a imagem Docker
docker build -t financa-pessoal .

# Execute o contêiner
docker run -p 5000:5000 --env-file .env financa-pessoal
```

#### Docker Compose

Você também pode usar Docker Compose para configurar a aplicação com um banco de dados PostgreSQL:

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "5000:5000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/financas
      - NODE_ENV=production
    depends_on:
      - db
    restart: always

  db:
    image: postgres:15
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=financas
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Execute com:

```bash
docker-compose up -d
```

### Heroku

Para implantar a aplicação no Heroku:

```bash
# Instale a CLI do Heroku
npm install -g heroku

# Faça login no Heroku
heroku login

# Crie um novo aplicativo
heroku create financa-pessoal

# Adicione um banco de dados PostgreSQL
heroku addons:create heroku-postgresql:hobby-dev

# Configure variáveis de ambiente
heroku config:set NODE_ENV=production

# Implante a aplicação
git push heroku main

# Execute as migrações
heroku run npm run migrate
```

### Railway

Para implantar a aplicação no Railway:

1. Crie uma conta em [Railway](https://railway.app)
2. Conecte seu repositório GitHub
3. Crie um novo projeto a partir do repositório
4. Adicione um serviço PostgreSQL no Railway
5. Configure as variáveis de ambiente:
   - `DATABASE_URL`: Obtido automaticamente do serviço PostgreSQL
   - `NODE_ENV`: production
6. Implante o aplicativo
7. Configure o domínio personalizado (opcional)

## Estrutura do Projeto

```
financa-pessoal/
├── client/                  # Código frontend
│   ├── src/
│   │   ├── components/      # Componentes React
│   │   ├── hooks/           # Hooks personalizados
│   │   ├── layouts/         # Layouts da aplicação
│   │   ├── lib/             # Bibliotecas utilitárias
│   │   ├── pages/           # Páginas da aplicação
│   │   └── main.tsx         # Ponto de entrada do frontend
├── server/                  # Código backend
│   ├── controllers/         # Controladores da API
│   ├── middleware/          # Middlewares Express
│   ├── swagger/             # Documentação Swagger
│   ├── index.ts             # Ponto de entrada do backend
│   └── routes.ts            # Definição de rotas
├── shared/                  # Código compartilhado
│   └── schema.ts            # Definições de schema (Drizzle + Zod)
├── components.json          # Configuração do Shadcn/UI
├── drizzle.config.ts        # Configuração do Drizzle ORM
├── package.json             # Dependências e scripts
└── tsconfig.json            # Configuração do TypeScript
```

## Guia da API

A API segue princípios RESTful e usa JSON para todas as solicitações e respostas. A documentação completa está disponível na rota `/docs` quando a aplicação está em execução.

### Autenticação

A API suporta dois métodos de autenticação:

1. **Autenticação baseada em sessão** - Para uso na interface web
2. **Autenticação baseada em token** - Para uso em integrações de API

Para obter um token de API:

1. Acesse a interface web e faça login
2. Vá para Configurações > API
3. Crie um novo token
4. Copie e guarde o token gerado (ele não será mostrado novamente)

#### Usando o Token de API

Inclua o token no cabeçalho HTTP `apikey` em todas as solicitações:

```
apikey: fin_seu_token_aqui
```

### Endpoint de Transações

Operações relacionadas a transações (receitas e despesas).

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/transactions` | Listar todas as transações |
| GET | `/api/transactions/recent` | Obter transações recentes |
| GET | `/api/transactions/:id` | Obter detalhes de uma transação |
| POST | `/api/transactions` | Criar uma nova transação |
| PUT | `/api/transactions/:id` | Atualizar uma transação (substituição completa) |
| PATCH | `/api/transactions/:id` | Atualizar uma transação (atualização parcial) |
| DELETE | `/api/transactions/:id` | Excluir uma transação |

### Endpoint de Categorias

Operações relacionadas a categorias de transações.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/categories` | Listar todas as categorias |
| GET | `/api/categories/:id` | Obter detalhes de uma categoria |
| POST | `/api/categories` | Criar uma nova categoria |
| PUT | `/api/categories/:id` | Atualizar uma categoria |
| DELETE | `/api/categories/:id` | Excluir uma categoria |

### Endpoint da Carteira

Operações relacionadas à carteira do usuário.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/wallet/current` | Obter detalhes da carteira atual |
| PUT | `/api/wallet/current` | Atualizar a carteira atual |

### Dashboard e Relatórios

Endpoints para obtenção de resumos e relatórios financeiros.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/dashboard/summary` | Obter resumo do dashboard |

## Exemplos de Uso da API

### Autenticação

```javascript
// Exemplo usando fetch
async function login(email, password) {
  const response = await fetch('http://localhost:5000/api/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email: email,
      senha: password
    })
  });

  return await response.json();
}

// Exemplo usando um token de API
async function getTransactionsWithToken(token) {
  const response = await fetch('http://localhost:5000/api/transactions', {
    method: 'GET',
    headers: {
      'apikey': token
    }
  });

  return await response.json();
}
```

### Criar uma Transação

```javascript
async function createTransaction(token, transactionData) {
  const response = await fetch('http://localhost:5000/api/transactions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'apikey': token
    },
    body: JSON.stringify({
      descricao: 'Compras do supermercado',
      valor: '150.00',
      tipo: 'Despesa',
      categoria_id: 1,
      carteira_id: 1,
      data_transacao: '2025-05-17 14:30:00',
      metodo_pagamento: 'Cartão de crédito',
      status: 'Efetivada'
    })
  });

  return await response.json();
}
```

### Obter Resumo do Dashboard

```javascript
async function getDashboardSummary(token) {
  const response = await fetch('http://localhost:5000/api/dashboard/summary', {
    method: 'GET',
    headers: {
      'apikey': token
    }
  });

  return await response.json();
}
```

### Exemplo com cURL

```bash
# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"usuario@exemplo.com","senha":"senha123"}'

# Obter transações com token
curl http://localhost:5000/api/transactions \
  -H "apikey: fin_seu_token_aqui"

# Criar uma transação
curl -X POST http://localhost:5000/api/transactions \
  -H "Content-Type: application/json" \
  -H "apikey: fin_seu_token_aqui" \
  -d '{
    "descricao": "Salário mensal",
    "valor": "3500.00",
    "tipo": "Receita",
    "categoria_id": 12,
    "carteira_id": 1,
    "data_transacao": "2025-05-15 09:00:00",
    "status": "Efetivada"
  }'
```

## Dicas de Segurança

1. **Proteja seus tokens de API**: Trate os tokens como senhas - nunca os compartilhe ou inclua em código público.
2. **Use HTTPS**: Em produção, sempre use HTTPS para criptografar as comunicações.
3. **Alternância de tokens**: Alterne regularmente seus tokens de API para limitar o impacto de uma exposição acidental.
4. **Limitação de taxa**: A API implementa limitação de taxa para evitar uso abusivo.
5. **Validação de entrada**: A aplicação valida todas as entradas, mas sempre filtre dados externos em integrações.

## Contribuição

Contribuições são bem-vindas! Siga estas etapas para contribuir:

1. Faça um fork do repositório
2. Crie um branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Faça commit das suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Faça push para o branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para mais detalhes.

## Agradecimentos

Um agradecimento especial à comunidade AI Makers Club pelo suporte, feedback e contribuições que ajudaram a tornar este projeto possível.

## Bruno

---

## 🐳 Rodando com Docker

Você pode rodar a aplicação facilmente usando Docker. Siga os passos abaixo:

```sh
# 1. Construa a imagem Docker
docker build -t financa-pessoal .

# 2. Execute o container (usando as variáveis do seu .env)
docker run -p 5000:5000 --env-file .env financa-pessoal
```

O Dockerfile já executa:
- `npm install` para instalar as dependências
- `npm run build` para buildar o frontend/backend
- `npm start` para rodar a aplicação

- O backend e o frontend serão servidos juntos na porta 5000.
- Certifique-se de que o arquivo `.env` está corretamente configurado na raiz do projeto.
- Para ambientes de produção, utilize variáveis seguras e um banco de dados acessível pelo container.

Se quiser rodar com Docker Compose (incluindo banco de dados PostgreSQL), veja o exemplo de `docker-compose.yml` na seção de instalação acima.