--DDL CRIACAO DA TABELA PARA EXERCICIOS
USE curso;
GO

CREATE TABLE FUNCIONARIOS(
	ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME VARCHAR(50) NOT NULL,
	SALARIO DECIMAL(10,2),
	SETOR VARCHAR(30)
);

--DML SELECT
--EXEMPLO SELECT
SELECT * FROM funcionarios;
--EXEMPLO SELECT
	SELECT nome, setor
	FROM funcionarios;

--EXEMPLO SELECT
	SELECT nome, setor AS depto
	FROM funcionarios;

--DML INSERT
	INSERT INTO funcionarios VALUES ('Joao', 1000,''), ('Jose',2000,''),('Alexandre', 3000, '');

--OU
	INSERT INTO funcionarios (nome,salario) VALUES ('Pedro',1000);



--simulando erro
	INSERT INTO funcionarios (nome,salario) VALUES ('Pedro','zaerre');

--simulando erro
	INSERT INTO funcionarios (salario) VALUES (2500);

-- DML UPDATE
	UPDATE funcionarios SET salario = '1500'
	WHERE id = '1'

-- OU Aumento de 50% sobre Salário atual.
	UPDATE funcionarios SET salario = salario * 1.5
	WHERE id = '1';

-- exemplo update com mais de um campo
	UPDATE funcionarios SET salario = salario * 1.5, setor='TI'
	WHERE id <> '1';

-- DML DELETE
	DELETE funcionarios
	WHERE id = '1';
