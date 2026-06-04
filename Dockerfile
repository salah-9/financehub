FROM node:20-bookworm-slim

# Instalar dependências do sistema necessárias para compilar pacotes nativos
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    libpixman-1-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    chromium \
    ca-certificates \
    fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia os arquivos de dependência
COPY package.json package-lock.json ./

# Instala as dependências
RUN npm install

# Instala drizzle-kit globalmente
RUN npm install -g drizzle-kit

# Copia todo o restante do código
COPY . .

# Copia o script de inicialização do banco
COPY init.sql /docker-entrypoint-initdb.d/

# Build do frontend/backend
RUN npm run build

# Exponha a porta padrão
EXPOSE 5000

# Comando para iniciar a aplicação
CMD ["npm", "start"]
