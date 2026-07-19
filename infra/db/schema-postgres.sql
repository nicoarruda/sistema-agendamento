DROP TABLE IF EXISTS criador_tabela CASCADE;
DROP TABLE IF EXISTS criador_coluna CASCADE;
DROP TABLE IF EXISTS criador_registro_dinamico CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

CREATE TABLE criador_tabela (
    id SERIAL PRIMARY KEY,
    nome_da_coluna VARCHAR(255) NOT NULL,
    tipo_de_dado VARCHAR(255) NOT NULL,
    criada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE criador_coluna (
    id SERIAL PRIMARY KEY,
    nome_da_coluna VARCHAR(255) NOT NULL,
    tipo_de_dado VARCHAR(255) NOT NULL,
    tabela_id INT REFERENCES criador_tabela(id) ON DELETE CASCADE,
    criada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE criador_registro_dinamico (
    id SERIAL PRIMARY KEY,
    tabela_id INT REFERENCES criador_tabela(id) ON DELETE CASCADE,
    registros_dinamicos JSONB NOT NULL,
    criada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    campos_dinamicos JSONB DEFAULT '{}'::jsonb,
    criada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE administradores_sistema (
    id SERIAL PRIMARY KEY,
    usuario_red_id VARCHAR(255) NOT NULL UNIQUE, -- Login de rede do gov/TI, por exemplo
    email_ti VARCHAR(255) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    nivel_acesso VARCHAR(255) NOT NULL, -- Ex: 'DBA', 'SUPORTE_TI', 'SUPER_ADMIN'
    ativo BOOLEAN DEFAULT TRUE,
    criada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_criador_tabela_nome ON criador_tabela(nome_da_coluna);
CREATE INDEX idx_criador_coluna_nome ON criador_coluna(nome_da_coluna);
CREATE INDEX idx_criador_registro_dinamico ON criador_registro_dinamico(tabela_id);
CREATE INDEX idx_usuarios ON usuarios(cpf);
CREATE INDEX idx_administradores_sistema ON administradores_sistema(usuario_red_id);