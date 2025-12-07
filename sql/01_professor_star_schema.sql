-- Desafio: Criando um Star_Schema para cenários de vendas
-- com power BI.
-- Autor: Roddy R. G.

-- Criando Banco de Dados e Tabelas
CREATE DATABASE universidade_dw;
USE universidade_dw;

-- DIMENSÃO DATA: dimensão de tempo/calendário.
CREATE TABLE dim_data (
    id_data INT PRIMARY KEY, 
    data_completa DATE NOT NULL,
    ano INT NOT NULL,
    semestre INT NOT NULL, 
    trimestre INT NOT NULL,
    mes INT NOT NULL,
    nome_mes VARCHAR(20) NOT NULL,
    dia_semana VARCHAR(20) NOT NULL,
    feriado BOOLEAN DEFAULT FALSE,
    periodo_academico VARCHAR(50),
    UNIQUE KEY (data_completa)
);
-- DESC dim_data;

-- DIMENSÃO PROFESSOR: Dados dos professores.
CREATE TABLE dim_professor (
    id_professor INT PRIMARY KEY,
    nome_professor VARCHAR(100) NOT NULL,
    titulacao VARCHAR(50),
    ano_ingresso YEAR,
    status ENUM('Ativo','Inativo','Afastado') DEFAULT 'Ativo',
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- DESC dim_professor;

-- DIMENSÃO DEPARTAMENTO: Informações dos departamentos.
CREATE TABLE dim_departamento (
    id_departamento INT PRIMARY KEY,
    nome_departamento VARCHAR(100) NOT NULL,
    campus VARCHAR(100) NOT NULL,
    sigla VARCHAR(10),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- DESC dim_departamento;

-- DIMENSÃO CURSO: Dados dos cursos oferecidos.
CREATE TABLE dim_curso (
    id_curso INT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    tipo_curso ENUM('Graduação','Pós-Graduação','Extensão') DEFAULT 'Graduação',
    modalidade ENUM('Presencial','EAD','Híbrido') DEFAULT 'Presencial',
    carga_horaria_total INT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- DESC dim_curso;

-- DIMENSÃO DISCIPLINA: Informações das disciplinas.
CREATE TABLE dim_disciplina (
    id_disciplina INT PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    codigo_disciplina VARCHAR(20),
    carga_horaria INT,
    creditos INT,
    tipo_disciplina ENUM('Obrigatória','Eletiva','Optativa') DEFAULT 'Obrigatória',
    nivel VARCHAR(20),
    possui_prerequisito BOOLEAN DEFAULT FALSE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- DESC dim_disciplina;

-- TABELA FATO_PROFESSOR: Tabela fato com métricas sobre atividades dos professores. 
CREATE TABLE fato_professor (
    id_fato INT AUTO_INCREMENT PRIMARY KEY,
    id_professor INT NOT NULL,
    id_departamento INT NOT NULL,
    id_curso INT NOT NULL,
    id_disciplina INT NOT NULL,
    id_data INT NOT NULL, -- Data de oferta da disciplina
-- Métricas:
    qtd_disciplinas_ministradas INT DEFAULT 1,
    qtd_cursos_envolvidos INT DEFAULT 1,
    qtd_prerequisitos_ministrados INT DEFAULT 0,
    indicador_coordenador BOOLEAN DEFAULT FALSE,
-- Chaves estrangeiras
    FOREIGN KEY (id_professor) REFERENCES dim_professor(id_professor),
    FOREIGN KEY (id_departamento) REFERENCES dim_departamento(id_departamento),
    FOREIGN KEY (id_curso) REFERENCES dim_curso(id_curso),
    FOREIGN KEY (id_disciplina) REFERENCES dim_disciplina(id_disciplina),
    FOREIGN KEY (id_data) REFERENCES dim_data(id_data)
-- Índices para performance
--    INDEX idx_professor (id_professor),
--    INDEX idx_data (id_data),
--    INDEX idx_departamento (id_departamento)
);
-- DESC fato_professor;

