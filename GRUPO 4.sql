-- ---------------------------------------
-- CRIANDO O NOSSO 
-- ---------------------------------------
DROP DATABASE IF EXISTS controle_propinas;
CREATE DATABASE controle_propinas;
USE controle_propinas;

-- ----------------------------------------
-- CRIANDO NOSSAS TABELAS
-- ----------------------------------------
CREATE TABLE curso (
    cod_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    descricao TEXT,
    duracao INT COMMENT 'Duração em meses',
    valor_propina DECIMAL(10, 2) NOT NULL,
    ano INT
);

-- ----------------------------------------------
-- CRIANDO A TABELA FUNCIONÁRIO
-- ----------------------------------------------
CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo ENUM('M', 'F'),
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cargo VARCHAR(50) NOT NULL
);

-- -----------------------------------------------
-- CRIANDO A TABELA ALUNO
-- -----------------------------------------------
CREATE TABLE aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo ENUM('M', 'F'),
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    data_nascimento DATE NOT NULL,
    endereco TEXT,
    cod_curso INT NOT NULL,
    FOREIGN KEY (cod_curso) REFERENCES curso(cod_curso)
);

-- -----------------------------------------------
-- CRIANDO A TABELA PROPINA
-- -----------------------------------------------
CREATE TABLE propina (
    cod_propina INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    mes INT NOT NULL COMMENT '1-12 para indicar o mês',
    valor DECIMAL(10, 2) NOT NULL,
    status ENUM('Pendente', 'Pago', 'Atrasado') DEFAULT 'Pendente',
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    UNIQUE KEY uk_propina_aluno_mes (id_aluno, mes)
);

-- -----------------------------------------------
-- CRIANDO A TABELA PAGANENTO
-- -----------------------------------------------
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

-- -----------------------------------------------
-- CRIANDO FUNCTION  PARA calcular_total_pagamentos_aluno
-- -----------------------------------------------
DELIMITER $$
CREATE FUNCTION calcular_total_pagamentos_aluno(aluno_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(valor_pago)
    INTO total
    FROM pagamento
    JOIN propina ON pagamento.cod_propina = propina.cod_propina
    WHERE propina.id_aluno = aluno_id;
    RETURN IFNULL(total, 0);
END$$
DELIMITER ;

-- -----------------------------------------------
-- CRIANDO PROCEDURE PARA registrar_pagamento
-- -----------------------------------------------
DELIMITER $$
CREATE PROCEDURE registrar_pagamento(
    IN p_cod_propina INT,
    IN p_id_funcionario INT,
    IN p_valor_pago DECIMAL(10,2),
    IN p_data DATETIME,
    IN p_metodo ENUM('Dinheiro', 'Transferência', 'Cartão', 'Outro')
)
BEGIN
    INSERT INTO pagamento (cod_propina, id_funcionario, valor_pago, data_pagamento, metodo_pagamento)
    VALUES (p_cod_propina, p_id_funcionario, p_valor_pago, p_data, p_metodo);

    UPDATE propina
    SET status = 'Pago'
    WHERE cod_propina = p_cod_propina;
END$$
DELIMITER ;

-- -----------------------------------------------
-- CRIANDO TRIGGER PARA atualizar_status_ao_pagamento
-- -----------------------------------------------
DELIMITER $$
CREATE TRIGGER trg_atualizar_status_propina
AFTER INSERT ON pagamento
FOR EACH ROW
BEGIN
    UPDATE propina
    SET status = 'Pago'
    WHERE cod_propina = NEW.cod_propina;
END$$
DELIMITER ;

-- -----------------------------------------------
-- CINSERINDO OS CURSOS
-- -----------------------------------------------

INSERT INTO curso (nome_curso, descricao, duracao, valor_propina, ano) VALUES ('Informática Básica', 'Curso introdutório de informática', 6, 5000.0, 2025),
('Contabilidade', 'Curso de fundamentos contábeis', 12, 7000.0, 2025),
('Programação Java', 'Curso de programação orientada a objetos', 9, 9000.0, 2025),
('Administração', 'Curso de gestão e administração de empresas', 18, 12000.0, 2025);

-- -----------------------------------------------
-- INSERINDO OS FUNCIONÁRIOS
-- -----------------------------------------------

INSERT INTO funcionario (nome, sexo, email, telefone, cargo) VALUES ('Fernanda Martins', 'F', 'fernanda.martins@exemplo.com', '923-221268', 'Secretário'),
 ('Beatriz Santos', 'M', 'beatriz.santos@exemplo.com', '923-474846', 'Atendente'),
('Igor Almeida', 'M', 'igor.almeida@exemplo.com', '923-273845', 'Atendente'),
('Carlos Almeida', 'M', 'carlos.almeida@exemplo.com', '923-152620', 'Tesoureiro'),
('Beatriz Ferreira', 'F', 'beatriz.ferreira@exemplo.com', '923-654511', 'Secretário');


-- -----------------------------------------------
-- INSERINDO OS ALUNOS
-- -----------------------------------------------

INSERT INTO aluno (nome, sexo, email, telefone, data_nascimento, endereco, cod_curso) VALUES ('Helena Pereira', 'F', 'helena.pereira@exemplo.com', '923-279057', '2000-04-20', 'Bairro 2', 3),
 ('Ana Ferreira', 'F', 'ana.ferreira@exemplo.com', '923-867563', '2001-08-04', 'Bairro 4', 1),
 ('Beatriz Almeida', 'F', 'beatriz.almeida@exemplo.com', '923-823498', '2005-12-25', 'Bairro 2', 2),
('Ana Barros', 'F', 'ana.barros@exemplo.com', '923-869127', '1996-02-27', 'Bairro 4', 2),
('Igor Silva', 'M', 'igor.silva@exemplo.com', '923-580890', '1995-12-22', 'Bairro 3', 2),
('Juliana Costa', 'F', 'juliana.costa@exemplo.com', '923-618587', '1997-01-01', 'Bairro 1', 4),
('Beatriz Pereira', 'F', 'beatriz.pereira@exemplo.com', '923-222241', '2004-12-18', 'Bairro 3', 4),
('Eduardo Santos', 'M', 'eduardo.santos@exemplo.com', '923-320911', '2004-12-09', 'Bairro 2', 2),
('Lucas Rodrigues', 'F', 'lucas.rodrigues@exemplo.com', '923-990591', '1999-06-04', 'Bairro 3', 1),
('Igor Rodrigues', 'F', 'igor.rodrigues@exemplo.com', '923-917586', '2003-01-20', 'Bairro 3', 3);


-- -----------------------------------------------
-- INSERINDO OS PROPINAS
-- -----------------------------------------------

INSERT INTO propina (id_aluno, mes, valor, status) VALUES (1, 1, 7000.0, 'Pendente'),
(1, 2, 9000.0, 'Atrasado'),
(1, 3, 7000.0, 'Atrasado'),
(2, 1, 9000.0, 'Atrasado'),
(2, 2, 5000.0, 'Atrasado'),
(2, 3, 7000.0, 'Pendente'),
(3, 1, 7000.0, 'Pago'),
(3, 2, 5000.0, 'Pago'),
(3, 3, 9000.0, 'Pendente'),
(4, 1, 9000.0, 'Atrasado'),
(4, 2, 5000.0, 'Atrasado'),
(4, 3, 9000.0, 'Pago'),
(5, 1, 7000.0, 'Pendente'),
(5, 2, 9000.0, 'Atrasado'),
(5, 3, 5000.0, 'Atrasado'),
(6, 1, 5000.0, 'Pago'),
(6, 2, 7000.0, 'Pago'),
(6, 3, 5000.0, 'Atrasado'),
(7, 1, 7000.0, 'Atrasado'),
(7, 2, 7000.0, 'Pago'),
(7, 3, 5000.0, 'Pago'),
(8, 1, 7000.0, 'Atrasado'),
(8, 2, 7000.0, 'Pago'),
(8, 3, 5000.0, 'Atrasado'),
(9, 1, 7000.0, 'Pago'),
(9, 2, 5000.0, 'Atrasado'),
(9, 3, 7000.0, 'Pago'),
(10, 1, 5000.0, 'Atrasado'),
(10, 2, 7000.0, 'Atrasado'),
(10, 3, 7000.0, 'Atrasado');


-- -----------------------------------------------
-- INSERINDO OS PAGAMENTOS
-- -----------------------------------------------
INSERT INTO pagamento (cod_propina, id_funcionario, valor_pago, data_pagamento, metodo_pagamento) VALUES (2, 2, 5000.0, '2025-06-30 00:00:00', 'Dinheiro'),
(3, 1, 5000.0, '2025-06-18 00:00:00', 'Outro'),
(7, 4, 7000.0, '2025-06-18 00:00:00', 'Transferência'),
(8, 4, 5000.0, '2025-06-12 00:00:00', 'Outro'),
(9, 1, 7000.0, '2025-06-06 00:00:00', 'Transferência'),
(12, 3, 7000.0, '2025-06-08 00:00:00', 'Outro'),
(13, 4, 7000.0, '2025-06-16 00:00:00', 'Transferência'),
(16, 4, 5000.0, '2025-06-27 00:00:00', 'Cartão'),
(18, 5, 7000.0, '2025-06-15 00:00:00', 'Outro'),
(19, 5, 7000.0, '2025-06-23 00:00:00', 'Outro'),
(20, 3, 5000.0, '2025-06-29 00:00:00', 'Dinheiro');

-- --------------------------------------------
-- CONSULTANDO NOSSAS INSERÇÕES
-- -------------------------------------------
SELECT * FROM aluno;
SELECT * FROM curso;
SELECT * FROM pagamento;
SELECT * FROM propina;
SELECT * FROM funcionario;




-- -----------------------------------------------
-- RELATÓRIOS E CONSULTAS IMPORTANTES
-- -----------------------------------------------

-- -----------------------------------------------------
-- LISTA DE ALUNOS DEVEDORES (com propinas em atraso ou pendentes)
SELECT 
    a.id_aluno, 
    a.nome AS nome_aluno, 
    c.nome_curso, 
    p.mes, 
    p.status
FROM aluno a
JOIN propina p ON a.id_aluno = p.id_aluno
JOIN curso c ON a.cod_curso = c.cod_curso
WHERE p.status IN ('Pendente', 'Atrasado');
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Quantos alunos pertencem a cada curso
SELECT 
    c.nome_curso, 
    COUNT(a.id_aluno) AS total_alunos
FROM curso c
LEFT JOIN aluno a ON c.cod_curso = a.cod_curso
GROUP BY c.cod_curso;
-- -----------------------------------------------------


-- -------------------------------------------------
-- QUANTOS ALUNOS JÁ PAGARAM PELO MENOS UMA PROPINA
-- -------------------------------------------------
SELECT 
    COUNT(DISTINCT propina.id_aluno) AS alunos_que_pagaram
FROM pagamento
JOIN propina ON pagamento.cod_propina = propina.cod_propina;


-- -----------------------------------------------------
-- QUANTAS PROPINAS FORAM ATENDIDADAS POR CADA FUNCIONÁRIO
-- -----------------------------------------------------
SELECT 
    f.id_funcionario, 
    f.nome AS funcionario, 
    COUNT(p.cod_pagamento) AS total_pagamentos
FROM funcionario f
LEFT JOIN pagamento p ON f.id_funcionario = p.id_funcionario
GROUP BY f.id_funcionario;

-- -----------------------------------------------------
-- VALOR TOTAL ARRECADADO PELOS FUNCIONARIOS
SELECT 
    f.id_funcionario, 
    f.nome AS funcionario, 
    SUM(pg.valor_pago) AS total_arrecadado
FROM funcionario f
JOIN pagamento pg ON f.id_funcionario = pg.id_funcionario
GROUP BY f.id_funcionario;
-- -----------------------------------------------------


-- -----------------------------------------------------
-- TOTAL DE PROPINAS PENDENTE, PAGA E EM ATRASO
-- -----------------------------------------------

SELECT 
    status, 
    COUNT(*) AS total
FROM propina
GROUP BY status;

-- --------------------------------------------------------
-- CURSOS COM MAIS DEVEDORES
-- --------------------------------------------------------
SELECT 
    c.nome_curso, 
    COUNT(DISTINCT a.id_aluno) AS devedores
FROM aluno a
JOIN curso c ON a.cod_curso = c.cod_curso
JOIN propina p ON a.id_aluno = p.id_aluno
WHERE p.status IN ('Pendente', 'Atrasado')
GROUP BY c.cod_curso
ORDER BY devedores DESC;

-- -----------------------------------------------------
-- LISTA DE ALUNOS SEM DIVIDA
-- -----------------------------------------------------

SELECT 
    a.id_aluno, 
    a.nome AS aluno, 
    calcular_total_pagamentos_aluno(a.id_aluno) AS total_pago
FROM aluno a;

-- ----------------------------------------------------------
-- FILTRANDO INFORMAÇÕES 

SELECT id_aluno, nome, sexo, endereco FROM aluno;
SELECT id_funcionario, nome, sexo, cargo FROM funcionario;
SELECT cod_curso, nome_curso, descricao FROM curso;


-- -----------------------------------------------------
-- LOCALIZAÇÃO DOS NOSSOS ALUNOS
SELECT endereco, COUNT(*) AS quant_aluno FROM aluno group by endereco;
-- -----------------------------------------------------

-- -----------------------------------------------------
-- STATUS DE PROPINAS
SELECT COUNT(*) FROM pagamento where metodo_pagamento = 'Dinheiro';
SELECT COUNT(*) FROM pagamento where metodo_pagamento = 'Cartão';
SELECT COUNT(*) FROM pagamento where metodo_pagamento = 'Transferência';
SELECT COUNT(*) FROM pagamento where metodo_pagamento = 'Outro';
-- ------------------------------------------------------