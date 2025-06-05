-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS controle_propinas;
USE controle_propinas;

-- Tabela Curso
CREATE TABLE curso (
    cod_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    descricao TEXT,
    duracao INT COMMENT 'Duração em meses',
    valor_propina DECIMAL(10, 2) NOT NULL
);

ALTER TABLE curso ADD COLUMN ano int;

INSERT INTO curso VALUES(DEFAULT, nome_curso, descricao, duracao, valor_propina);
INSERT INTO curso VALUES(DEFAULT, 'Excel Avançado', 'Aprenda Excel na prática', 1, '7000');
SELECT * FROM curso;


-- Tabela Funcionário
CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo ENUM ('M', 'F'),
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cargo VARCHAR(50) NOT NULL
);

INSERT INTO funcionario VALUES(DEFAULT, nome_funcionario, sexo, email, telefone, cargo);
INSERT INTO funcionario VALUES(DEFAULT, 'Excel Avançado', 'Aprenda Excel na prática', 1, '7000');
SELECT * FROM funcionario;



-- Tabela Aluno
CREATE TABLE aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo ENUM ('M', 'F'),
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    data_nascimento DATE NOT NULL,
    endereco TEXT,
    cod_curso INT NOT NULL,
    FOREIGN KEY (cod_curso) REFERENCES curso(cod_curso)
);

INSERT INTO aluno VALUES(DEFAULT, nome, sexo, email, telefone, data_nascimento, endereco, cod_propina);
INSERT INTO aluno VALUES(DEFAULT, 'Excel Avançado', 'Aprenda Excel na prática', 1, '7000');
SELECT * FROM aluno;

-- Tabela Propina
CREATE TABLE propina (
    cod_propina INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    mes INT NOT NULL COMMENT '1-12 para indicar o mês',
    valor DECIMAL(10, 2) NOT NULL,
    status ENUM('Pendente', 'Pago', 'Atrasado') DEFAULT 'Pendente',
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    UNIQUE KEY uk_propina_aluno_mes (id_aluno, mes)
);

INSERT INTO propina VALUES(DEFAULT, nome_aluno, mes, duracao, valor, status);

SELECT * FROM propina;

-- Tabela Pagamento
CREATE TABLE pagamento (
    cod_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    cod_propina INT NOT NULL,
    id_funcionario INT NOT NULL,
    valor_pago DECIMAL(10, 2) NOT NULL,
    data_pagamento DATETIME NOT NULL,
    metodo_pagamento ENUM('Dinheiro', 'Transferência', 'Cartão', 'Outro') NOT NULL,
    FOREIGN KEY (cod_propina) REFERENCES propina(cod_propina),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

INSERT INTO pagamento VALUES(DEFAULT, cod_propina, id_funcionario, valor_pago, data_pagamento, metodo_pagamento);

SELECT * FROM pagamento;


-- Filtrando informações 

SELECT id_aluno, nome, sexo, endereco FROM aluno;
SELECT id_funcionario, nome, sexo, cargo FROM funcionario;
SELECT cod_curso, nome_curso, descricao FROM curso;

-- EFETUANDO RELACIONAMENTO ENTRE AS TABELAS
-- aluno e curso
SELECT aluno.id_aluno, aluno.nome, curso.nome_curso, ano FROM aluno JOIN curso ON aluno.id_aluno = curso.cod_curso;
-- aluno e a propina
SELECT aluno.id_aluno, aluno.nome, propina.mes, propina.status FROM aluno JOIN propina ON aluno.id_aluno = propina.cod_propina;
-- 
SELECT funcionario.id_funcionario, funcionario.nome, pagamento.valor_pago FROM funcionario RIGHT JOIN pagamento ON funcionario.id_funcionario = pagamento.cod_pagamento;
--
SELECT propina.cod_propina, propina.mes, pagamento.valor_pago, pagamento.metodo_pagamento FROM propina JOIN pagamento ON propina.cod_propina = pagamento.cod_pagamento;
-- 

-- O total de todos os pagamentos---------
SELECT SUM(valor_pago) FROM pagamento;

-- Quantos pagamentos recebemos----------
SELECT COUNT(valor_pago) FROM pagamento;

-- Quantos cursos temos
SELECT COUNT(nome_curso) FROM curso;

-- Quantos alunos-------
SELECT COUNT(nome) FROM aluno;

-- Status de propinas---
SELECT COUNT(*) FROM propina where status = 'Pago';
SELECT COUNT(*) FROM propina where status = 'Pendente';
SELECT COUNT(*) FROM propina where status = 'Atrasado';

-- revendo a localização dos nossos alunos
SELECT endereco, COUNT(*) AS quant_aluno FROM aluno group by endereco;

-- Status de propinas---
SELECT COUNT(*) FROM pagamento where metodo_pagamento = 'Dinheiro';
SELECT COUNT(*) FROM pagamento where metodo_pagamento = 'Cartão';
SELECT COUNT(*) FROM pagamento where metodo_pagamento = 'Transferência';
SELECT COUNT(*) FROM pagamento where metodo_pagamento = 'Outro';