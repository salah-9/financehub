# 📋 Guia Completo de Deployment do FinanceHub no Easypanel

**Projeto:** FinanceHub
**Versão:** 0.0.19
**Data:** 2026-03-30
**Autor:** Ellan15 (GitHub)
**Repositório Privado:** https://github.com/Ellan15/financehub

---

## 🚀 Pré-requisitos

Antes de iniciar o deployment, certifique-se de ter:

- ✅ VPS Hostinger 8GB (Plano Anual) - com Easypanel instalado
- ✅ Domínio registrado (recomendado: Registro.br)
- ✅ Cloudflare configurado com os nameservers
- ✅ PostgreSQL instalado no Easypanel
- ✅ N8N v1.119.0 configurado
- ✅ Credenciais de API: OpenAI, Google Gemini, ASAAS, UAZAPI

---

## 📝 Passo 1: Preparar o Repositório GitHub

### 1.1 Criar Repositório Privado

```bash
# Se ainda não autenticou no GitHub CLI
gh auth login

# Criar repositório privado
gh repo create financehub --private --source=. --remote=origin --push
```

### 1.2 Adicionar Token de Acesso (para Easypanel)

1. Acesse: https://github.com/settings/tokens
2. Clique em "Generate new token (classic)"
3. Configure as permissões:
   - ✅ `repo` (acesso completo ao repositório)
   - ✅ `admin:repo_hook` (webhooks)
4. Copie o token gerado

**⚠️ Importante:** Guarde este token com segurança!

---

## 🔧 Passo 2: Configurar GitHub no Easypanel

### 2.1 Adicionar Token do GitHub

1. Acesse o Easypanel: `https://<SEU_IP_VPS>:3000`
2. Vá em **Configurações** → **GitHub**
3. Cole o token gerado

### 2.2 Instalar a Aplicação via GitHub

1. No Easypanel, clique em **"Criar Aplicativo"**
2. Selecione a aba **"Github"**
3. Preencha os campos:

| Campo | Valor |
|-------|-------|
| **Proprietário** | Ellan15 |
| **Repositório** | financehub |
| **Ramo** | main |
| **Caminho de Build** | / |
| **Dockerfile** | Dockerfile |

4. Clique em **"Salvar"**

---

## 🗄️ Passo 3: Configurar Variáveis de Ambiente

### 3.1 Acessar Configurações da Aplicação

1. No Easypanel, acesse seu aplicativo **FinanceHub**
2. Vá em **"Environment Variables"** (ou **"Variáveis de Ambiente"**)

### 3.2 Adicionar as Variáveis

Cole as seguintes variáveis no Easypanel:

```env
# Sessão e Segurança
SESSION_SECRET=gqCIgEOmdliU9Ugz7F5t0aDF0ENW6uT3EHqeHPXkP0mtrbIJrBfJ+vb4d2JxbdUOV6uQiNyK++q+BhLoD+UjJA==

# Banco de Dados
DATABASE_URL=<sua_credencial_postgres>

# Webhook N8N (Ativação de Usuários)
WEBHOOK_ATIVACAO_URL=https://workflow.seudominio.com/webhook/ativacao

# URL Base da Aplicação
BASE_URL=https://app.seudominio.com

# Idioma Padrão
DEFAULT_LOCALE=pt-br

# ASAAS (Pagamentos)
ASAAS_API_KEY="<SEU_TOKEN_ASAAS>"
ASAAS_WEBHOOK_SECRET=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2
ASAAS_ENVIRONMENT=production

# UAZAPI (WhatsApp Business)
UAZAPI_URL=https://sua-instancia.uazapi.dev
UAZAPI_TOKEN=<seu_token_uazapi>
```

**Descrição das Variáveis:**

| Variável | Descrição |
|----------|-----------|
| `SESSION_SECRET` | Chave secreta para sessões. **Não altere após configuração inicial!** |
| `DATABASE_URL` | String de conexão PostgreSQL do Easypanel |
| `WEBHOOK_ATIVACAO_URL` | URL do webhook N8N para notificações |
| `BASE_URL` | URL pública da aplicação |
| `ASAAS_API_KEY` | Token de API do ASAAS para pagamentos |
| `ASAAS_ENVIRONMENT` | `sandbox` para testes ou `production` para produção |
| `UAZAPI_*` | Credenciais do WhatsApp Business API |

---

## 💾 Passo 4: Consolidar o Banco de Dados

### 4.1 Acessar o Console da Aplicação

1. No Easypanel, abra seu aplicativo **FinanceHub**
2. Clique em **"Console"** (terminal)
3. Clique em **"sh"** para iniciar o terminal

### 4.2 Executar Migrações

```bash
# Executar migrações do banco de dados
npm run start:migration

# Quando perguntado: "Confirma que estas são as credenciais corretas?"
# Responda: S

# Quando perguntado: "Deseja zerar o Banco de dados?"
# Responda: S
# ⚠️ ATENÇÃO: Esta ação apagará todos os dados!
```

### 4.3 Ativar Idiomas

```bash
npm run import:locale pt-br
npm run import:locale en-us
npm run import:locale es-es
```

### 4.4 Finalizar

```bash
exit
```

Clique no botão **"Restart"** (segundo botão ao lado de "Implantar")

---

## 🌐 Passo 5: Configurar Domínio

### 5.1 Apontar Subdomínio para a Aplicação

1. Na lateral do Easypanel, dentro da aplicação, clique em **"Domínios"**
2. Clique em **"Adicionar Domínio"**
3. Preencha:

| Campo | Valor |
|-------|-------|
| **Host** | app.seudominio.com |
| **Porta** | 5000 |

4. Clique em **"Criar"**

### 5.2 Configurar DNS na Cloudflare

1. Acesse: https://dash.cloudflare.com
2. Selecione seu domínio
3. Vá em **"DNS"** → **"Registros"**
4. Crie um registro **A**:

```
Nome: app
Endereço IPv4: <SEU_IP_VPS>
Status: Apenas DNS (sem proxy)
TTL: Auto
```

---

## 🧪 Passo 6: Testar o Deployment

### Checklist de Verificação:

- ✅ Acessar: `https://app.seudominio.com`
- ✅ Fazer login com credenciais padrão:
  - E-mail: `teste@teste.com`
  - Senha: `admin123`
- ✅ **Mudar a senha padrão imediatamente!**
- ✅ Criar novo usuário
- ✅ Verificar webhook de ativação (WhatsApp)
- ✅ Testar cobrança no ASAAS
- ✅ Validar workflows do N8N

---

## 🔐 Passo 7: Configurações de Segurança

### Após o Primeiro Acesso:

1. **Altere as credenciais padrão:**
   - E-mail: `teste@teste.com` → seu e-mail
   - Senha: `admin123` → senha forte

2. **Habilite HTTPS:**
   - O Easypanel configura automaticamente via Let's Encrypt

3. **Configure Backup:**
   - Easypanel → Configurações → Backup
   - Configure backup automático do PostgreSQL

4. **Monitore os Logs:**
   - Easypanel → Aplicativo → Logs
   - Verifique erros de deployment

---

## 📱 Passo 8: Integração UAZAPI (WhatsApp Business)

1. Acesse: https://uazapi.dev/
2. Contrate 1 instância de WhatsApp (R$ 29,00/mês)
3. Leia o QR Code com seu WhatsApp Business
4. Configure no N8N:
   - URL do servidor UAZAPI
   - Token de autenticação
5. Atualize a variável `UAZAPI_TOKEN` no Easypanel

---

## 💳 Passo 9: Integração ASAAS (Pagamentos)

1. Acesse: https://www.asaas.com/
2. Crie/complete sua conta
3. Vá em **Integrações** → **Chaves de API**
4. Gere sua chave de API
5. Configure no Easypanel (ver Passo 3)

---

## 🔄 Passo 10: Deploy Contínuo (CI/CD)

### Atualizar a Aplicação:

Toda vez que você fizer `git push` para a branch `main`:

1. GitHub disparará um webhook
2. Easypanel receberá a notificação
3. Easypanel fará rebuild automático da imagem Docker
4. A aplicação será atualizada

```bash
# Fluxo de atualização:
git add .
git commit -m "Descrição da mudança"
git push origin main

# Aguarde 2-5 minutos para o Easypanel fazer o rebuild
```

---

## 🆘 Troubleshooting

### Erro: "Connection refused"
- Verifique se o PostgreSQL está rodando
- Confira as credenciais de `DATABASE_URL`

### Erro: "Webhook not found"
- Verifique a URL do webhook no N8N
- Certifique-se que o N8N está rodando

### Aplicação não sobe após push
- Verifique os logs: Easypanel → Aplicativo → Logs
- Confira se as variáveis de ambiente estão corretas

### WhatsApp Business não envia mensagens
- Verifique credenciais da UAZAPI
- Teste o webhook manualmente no N8N

---

## 📞 Suporte

- **WhatsApp:** 55 800 809 6151
- **Email:** seu-email@seudominio.com
- **Documentação N8N:** https://docs.n8n.io/
- **Documentação Easypanel:** https://www.easypanel.io/

---

## ✅ Deployment Concluído com Sucesso!

Parabéns! Sua aplicação FinanceHub está online e pronta para uso.

**Próximos Passos:**
1. Monitorar performance no Grafana (se configurado)
2. Configurar alertas de erros
3. Fazer backup regular do banco de dados
4. Atualizar versão periodicamente

---

*Documento gerado em: 2026-03-30*
*Versão do FinanceHub: 0.0.19*
