--MINI ERP
--USE master
--DROP DATABASE MINIERP_MULT
--GO
CREATE DATABASE MINIERP_MULTI
GO
USE MINIERP_MULTI


--Cadastros complementares por �rea
--Criando tabelas sem depend�ncias/dependentes
CREATE TABLE EMPRESA(
	COD_EMPRESA INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_EMPRESA VARCHAR(50),
	FANTASIA VARCHAR(20)
)


--Tabelas Unidade Federal
--DROP TABLE UF
CREATE TABLE UF(
	COD_UF VARCHAR(2) NOT NULL PRIMARY KEY,
	NOME_UF VARCHAR(30) NOT NULL,
)

--Tabela Cidades
CREATE TABLE CIDADE(
	COD_CIDADE VARCHAR(7) NOT NULL PRIMARY KEY,
	COD_UF VARCHAR(2) NOT NULL,
	NOME_MUN VARCHAR(50) NOT NULL,
	CONSTRAINT FK_CID1 FOREIGN KEY(COD_UF) REFERENCES UF(COD_UF)
)


--Criando Tabelas CLIENTES
--DROP TABLE CLIENTES
CREATE TABLE CLIENTES(
	COD_EMPRESA INT NOT NULL,
	ID_CLIENTE INT IDENTITY(1,1) NOT NULL,
	RAZAO_CLIENTE VARCHAR(100) NOT NULL,
	FANTASIA VARCHAR(15) NOT NULL,
	ENDERECO VARCHAR(50) NOT NULL,
	NRO VARCHAR(10) NOT NULL,
	BAIRRO VARCHAR(20) NOT NULL,
	COD_CIDADE VARCHAR(7) NOT NULL,
	CEP VARCHAR(8),
	CNPJ_CPF VARCHAR(15),
	TIPO_CLIENTE NCHAR(1)CONSTRAINT CK_TC1 CHECK (TIPO_CLIENTE in ('F', 'J')),
	DATA_CADASTRO DATETIME NOT NULL,
	COD_PAGTO INT,
	CONSTRAINT PK_CLI1 PRIMARY KEY (COD_EMPRESA, ID_CLIENTE),
	CONSTRAINT FK_CLI1 FOREIGN KEY (COD_CIDADE)
	REFERENCES CIDADES(COD_CIDADE),
	CONSTRAINT FK_CLI2 FOREIGN KEY (COD_EMPRESA)
	REFERENCES EMPRESA(COD_EMPRESA)
)

--Cria��o Tabela Fornecedores
CREATE TABLE FORNECEDORES(
	COD_EMPRESA INT NOT NULL,
	ID_FOR INT IDENTITY(1,1),
	RAZAO_FORNEC VARCHAR(100) NOT NULL,
	FANTASIA VARCHAR(15) NOT NULL,
	ENDERECO VARCHAR(50) NOT NULL,
	NRO VARCHAR(10) NOT NULL,
	BAIRRO VARCHAR(20) NOT NULL,
	COD_CIDADE VARCHAR(7) NOT NULL,
	CEP VARCHAR(8),
	CNPJ_CPF VARCHAR(15),
	TIPO_FORNEC NCHAR(1) CONSTRAINT CK_TF1 CHECK (TIPO_FORNEC in ('F', 'J')),
	DATA_CADASTRO DATETIME NOT NULL,
	COD_PAGTO INT,
	CONSTRAINT PK_FOR1 PRIMARY KEY (COD_EMPRESA, ID_FOR),
	CONSTRAINT FK_FOR1 FOREIGN KEY (COD_CIDADE)
	REFERENCES CIDADES(COD_CIDADE),
	CONSTRAINT FK_FOR2 FOREIGN KEY (COD_EMPRESA)
	REFERENCES EMPRESA(COD_EMPRESA)
)

--Verificando
SELECT * FROM FORNECEDORES

--Tabelas Tipo de Material
CREATE TABLE TIPO_MAT(
	COD_EMPRESA INT NOT NULL,
	COD_TIP_MAT INT NOT NULL,
	DESC_TIP_MAT VARCHAR(20) NOT NULL,
	CONSTRAINT PK_TIP_M1 PRIMARY KEY (COD_EMPRESA, COD_TIP_MAT),
	CONSTRAINT FK_TIP_M1 FOREIGN KEY (COD_EMPRESA)
	REFERENCES EMPRESA(COD_EMPRESA)
)

--Criando Tabelas Material
CREATE TABLE MATERIAL(
	COD_EMPRESA INT NOT NULL,
	COD_MAT INT NOT NULL,
	DESCRICAO VARCHAR(50) NOT NULL,
	PRECO_UNIT DECIMAL(10,2) NOT NULL,
	COD_TIP_MAT INT NOT NULL,
	ID_FOR INT,
	CONSTRAINT PK_MAT1 PRIMARY KEY (COD_EMPRESA, COD_MAT),
	CONSTRAINT FK_MAT1 FOREIGN KEY (COD_EMPRESA, COD_TIP_MAT)
	REFERENCES TIPO_MAT(COD_EMPRESA,COD_TIP_MAT)
	/*
	CONSTRAINT FK_MAT2 FOREIGN KEY (COD_EMPRESA, ID_FOR)
	REFERENCES FORNECEDORES(COD_EMPRESA,ID_FOR)
	*/
	--ALTER TABLE MATERIAL DROP CONSTRAINT FK_MAT2
)

--Criando INDEX
CREATE INDEX IX_MAT ON MATERIAL(COD_EMPRESA, COD_TIP_MAT)


--Produ��o
--DROP TABLE ORDEM_PROD
CREATE TABLE ORDEM_PROD(
	COD_EMPRESA INT NOT NULL,
	ID_ORDEM INT IDENTITY(1,1) NOT NULL,
	COD_MAT_PROD INT NOT NULL,
	QTD_PLAN DECIMAL(10,2) NOT NULL,
	QTD_PROD DECIMAL(10,2) NOT NULL,
	DATA_INI DATE,
	DATA_FIM DATE,
	SITUACAO CHAR(1),--A=ABERTA, P=PLANEJADA, F=FECHADA
	CONSTRAINT PK_OP1 PRIMARY KEY (COD_EMPRESA, ID_ORDEM),
	CONSTRAINT FK_OP1 FOREIGN KEY (COD_EMPRESA, COD_MAT_PROD)
	REFERENCES MATERIAL(COD_EMPRESA, COD_MAT)
)

--Cria��o de Tabelas Apontamentos de Produ��o
--DROP TABEL APONTAMENTOS
CREATE TABLE APONTAMENTOS(
	COD_EMPRESA INT NOT NULL,
	ID_APON INT IDENTITY(1,1) NOT NULL,
	ID_ORDEM INT NOT NULL,
	COD_MAT_PROD INT,
	QTD_APON DECIMAL(10,2),
	DATA_APON DATETIME NOT NULL,
	--Campo Lote Criado no final
	--Login, Ser� criado ap�s cria��o da tabela usu�rios
	CONSTRAINT FK_APON1 FOREIGN KEY (COD_EMPRESA, COD_MAT_PROD)
	REFERENCES MATERIAL(COD_EMPRESA,COD_MAT),
	CONSTRAINT FK_APON2 FOREIGN KEY (COD_EMPRESA, ID_ORDEM)
	REFERENCES ORDEM_PROD(COD_EMPRESA, ID_ORDEM),
	CONSTRAINT PK_APON1 PRIMARY KEY (COD_EMPRESA, ID_APON)
)

--Cria��o da Tabela Ficha T�cnica
CREATE TABLE FICHA_TECNICA(
	COD_EMPRESA INT NOT NULL,
	ID_REF INT IDENTITY NOT NULL PRIMARY KEY,
	COD_MAT_PROD INT NOT NULL,
	COD_MAT_NECES INT NOT NULL,
	QTD_NECES DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_FIC1 FOREIGN KEY (COD_EMPRESA, COD_MAT_PROD)
	REFERENCES MATERIAL(COD_EMPRESA, COD_MAT),
	CONSTRAINT FK_FIC2 FOREIGN KEY (COD_EMPRESA, COD_MAT_NECES)
	REFERENCES MATERIAL (COD_EMPRESA, COD_MAT)
)

--Cria��o da Tabela Consumo
--DROP TABLE CONSUMO
CREATE TABLE CONSUMO(
	COD_EMPRESA INT NOT NULL,
	ID_APON INT NOT NULL,
	COD_MAT_NECES INT NOT NULL,
	QTD_CONSUMIDA DECIMAL(10,2) NOT NULL,
	LOTE VARCHAR(20) NOT NULL,
	CONSTRAINT FK_CONS1 FOREIGN KEY (COD_EMPRESA, COD_MAT_NECES)
	REFERENCES MATERIAL(COD_EMPRESA, COD_MAT),
	CONSTRAINT FK_CONS2 FOREIGN KEY (COD_EMPRESA, ID_APON)
	REFERENCES APONTAMENTOS (COD_EMPRESA, ID_APON)
)

--Cria��o da Tabela Suprimentos
CREATE TABLE ESTOQUE(
	COD_EMPRESA INT NOT NULL,
	COD_MAT INT NOT NULL,
	QTD_SALDO DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_EST1 FOREIGN KEY (COD_EMPRESA, COD_MAT)
	REFERENCES MATERIAL(COD_EMPRESA, COD_MAT)
)

--Cria��o Tabela ESTOQUE_LOTE
--DROP TABLE ESTOQUE_LOTE
CREATE TABLE ESTOQUE_LOTE(
	COD_EMPRESA INT NOT NULL,
	COD_MAT INT NOT NULL,
	LOTE VARCHAR(20) NOT NULL,
	QTD_LOTE DECIMAL(10,2) NOT NULL,
	CONSTRAINT PK_ESTL1 PRIMARY KEY (COD_EMPRESA, COD_MAT, LOTE), --PK COMPOSTA
	CONSTRAINT FK_ESTL1 FOREIGN KEY (COD_EMPRESA, COD_MAT)
	REFERENCES MATERIAL (COD_EMPRESA, COD_MAT)
)

--Cria��o Tabela MOV ESTOQUE
--DROP TABLE ESTOQUE_MOV
CREATE TABLE ESTOQUE_MOV(
	COD_EMPRESA INT NOT NULL,
	ID_MOV INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	TIPO_MOV VARCHAR(1), --S=SA�DA, E=ENTRADA
	COD_MAT INT NOT NULL,
	LOTE VARCHAR(20) NOT NULL,
	QTD DECIMAL(10,2) NOT NULL,
	DATA_MOV DATE NOT NULL,
	DATA_HORA DATETIME NOT NULL,
	CONSTRAINT FK_ESTM1 FOREIGN KEY (COD_EMPRESA, COD_MAT)
	REFERENCES MATERIAL(COD_EMPRESA, COD_MAT)
	--CAMPO LOGIN, TABELA, ESTOQUE_MOV, CRIA��O AP�S A TABELA USU�RIO
)

--Cria��o Tabela PED_COMPRAS
--DROP TABLE PED_COMPRAS
CREATE TABLE PED_COMPRAS(
	COD_EMPRESA INT NOT NULL,
	NUM_PEDIDO INT NOT NULL,
	ID_FOR INT NOT NULL,
	COD_PAGTO INT NOT NULL, --Alterar COD_PAGTO tabela PED_COMPRAS para FOREIGN KEY ap�s Tabela COND_PAGTO
	DATA_PEDIDO DATE NOT NULL,
	DATA_ENTREGA DATE NOT NULL,
	SITUACAO NCHAR(1) NOT NULL,
	TOTAL_PED DECIMAL(10,2),
	CONSTRAINT FK_PEDC1 FOREIGN KEY (COD_EMPRESA, ID_FOR)
	REFERENCES FORNECEDORES (COD_EMPRESA, ID_FOR),
	CONSTRAINT PK_PEDC1 PRIMARY KEY (COD_EMPRESA, NUM_PEDIDO)
)

--Cria��o da Tabela PEDIDO COMPRAS
CREATE TABLE PED_COMPRAS_ITENS(
	COD_EMPRESA INT NOT NULL,
	NUM_PEDIDO INT NOT NULL,
	SEQ_MAT INT NOT NULL,
	COD_MAT INT NOT NULL,
	QTD INT NOT NULL,
	VAL_UNIT DECIMAL(10,2) NOT NULL,
	CONSTRAINT PK_PEDCIT1 PRIMARY KEY (COD_EMPRESA, NUM_PEDIDO, SEQ_MAT),
	CONSTRAINT FK_PEDIT1 FOREIGN KEY (COD_EMPRESA, NUM_PEDIDO)
	REFERENCES PED_COMPRAS(COD_EMPRESA, NUM_PEDIDO),
	CONSTRAINT FK_PEDIT2 FOREIGN KEY (COD_EMPRESA, COD_MAT)
	REFERENCES MATERIAL (COD_EMPRESA, COD_MAT)
)

--RH
--~Cria��o Tabela CENTRO DE CUSTO
CREATE TABLE CENTRO_CUSTO(
	COD_EMPRESA INT NOT NULL,
	COD_CC VARCHAR(4) NOT NULL,
	NOME_CC VARCHAR(20) NOT NULL,
	CONSTRAINT PK_CC1 PRIMARY KEY (COD_EMPRESA, COD_CC),
	CONSTRAINT FK_CC1 FOREIGN KEY (COD_EMPRESA)
	REFERENCES EMPRESA (COD_EMPRESA)
)

--Cria��o Tabela CARGOS
CREATE TABLE CARGOS(
	COD_EMPRESA INT NOT NULL,
	COD_CARGO INT IDENTITY(1,1) NOT NULL,
	NOME_CARGO VARCHAR(50),
	CONSTRAINT PK_CARG1 PRIMARY KEY (COD_EMPRESA, COD_CARGO),
	CONSTRAINT FK_CARG1 FOREIGN KEY (COD_EMPRESA)
	REFERENCES EMPRESA(COD_EMPRESA)
)

--Cria��o Tabela FUNCIONARIO
--DROP TABLE FUNCIONARIO
CREATE TABLE FUNCIONARIO(
	COD_EMPRESA INT NOT NULL,
	MATRICULA INT NOT NULL,
	COD_CC VARCHAR(4) NOT NULL,
	NOME VARCHAR(50) NOT NULL,
	RG VARCHAR(15) NOT NULL,
	CPF VARCHAR(15) NOT NULL,
	ENDERECO VARCHAR(50) NOT NULL,
	NUMERO VARCHAR(10) NOT NULL,
	BAIRRO VARCHAR(50) NOT NULL,
	COD_CIDADE VARCHAR(7) NOT NULL,
	DATA_ADMISS DATE NOT NULL,
	DATE_DEMISS DATE,
	DATA_NASC DATE NOT NULL,
	TELEFONE VARCHAR(15) NOT NULL,
	COD_CARGO INT NOT NULL,
	CONSTRAINT FK_FUNC1 FOREIGN KEY (COD_EMPRESA, COD_CC)
	REFERENCES CENTRO_CUSTO (COD_EMPRESA, COD_CC),
	CONSTRAINT FK_FUNC2 FOREIGN KEY (COD_CIDADE)
	REFERENCES CIDADES(COD_CIDADE),
	CONSTRAINT FK_FUNC3 FOREIGN KEY (COD_EMPRESA, COD_CARGO)
	REFERENCES CARGOS(COD_EMPRESA, COD_CARGO),
	CONSTRAINT PK_FUNC1 PRIMARY KEY (COD_EMPRESA, MATRICULA)
)

--Cria��o Tabela SALARIO
CREATE TABLE SALARIO(
	COD_EMPRESA INT NOT NULL,
	MATRICULA INT NOT NULL,
	SALARIO DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_SAL2 FOREIGN KEY (COD_EMPRESA, MATRICULA)
	REFERENCES FUNCIONARIO(COD_EMPRESA, MATRICULA),
	CONSTRAINT PK_SAL1 PRIMARY KEY (COD_EMPRESA, MATRICULA)
)

--Cria��o Tabela FOLHA DE PAGTO
--DROP TABLE FOLHA_PAGTO
CREATE TABLE FOLHA_PAGTO(
	COD_EMPRESA INT NOT NULL,
	MATRICULA INT NOT NULL,
	TIPO_PGTO CHAR(1) NOT NULL, --(M=FOLHA, A=ADTO, F=FERIAS, D=13�, R=RESC)
	TIPO CHAR(1) NOT NULL, --P=PROVENTOS, D=DESCONTO
	EVENTO VARCHAR(30) NOT NULL,
	MES_REF VARCHAR(2) NOT NULL,
	ANO_REF VARCHAR(4) NOT NULL,
	DATA_PAGTO DATE NOT NULL,
	VALOR DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_FP1 FOREIGN KEY (COD_EMPRESA, MATRICULA)
	REFERENCES FUNCIONARIO (COD_EMPRESA, MATRICULA)
)

--Criando INDEX
CREATE INDEX IX1_FOLHA ON FOLHA_PAGTO (COD_EMPRESA, MATRICULA)

--Seguran�a
--Cria��o da Tabela USUARIOS
CREATE TABLE USUARIOS(
	COD_EMPRESA INT NOT NULL,
	LOGIN VARCHAR(30) NOT NULL PRIMARY KEY,
	MATRICULA INT NOT NULL,
	SENHA VARCHAR(32) NOT NULL,
	SITUACAO CHAR(1) NOT NULL, --A=ATIVO, B=BLOQUEADO
	CONSTRAINT FK_US1 FOREIGN KEY (COD_EMPRESA, MATRICULA)
	REFERENCES FUNCIONARIO (COD_EMPRESA, MATRICULA)
)

--Financeiro
--Cria��o da Tabela CONTAS A RECEBER
CREATE TABLE CONTAS_RECEBER(
	COD_EMPRESA INT NOT NULL,
	ID_DOC INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ID_CLIENTE INT NOT NULL,
	ID_DOC_ORG INT NOT NULL, --ALTER CAMPO ID_DOC_ORIG PARA FK TABELA NOT_FISCAL
	PARC INT NOT NULL,
	DATA_VENC DATE NOT NULL,
	DATA_PAGTO DATE,
	VALOR DECIMAL(10,2),
	CONSTRAINT FK_CR1 FOREIGN KEY (COD_EMPRESA, ID_CLIENTE)
	REFERENCES CLIENTES(COD_EMPRESA, ID_CLIENTE)
)

--Cria��o da Tabela CONTAS A PAGAR
--DROP TABLE CONTAS_PAGAR
CREATE TABLE CONTAS_PAGAR(
	COD_EMPRESA INT NOT NULL,
	ID_DOC INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ID_FOR INT NOT NULL,
	ID_DOC_ORIG INT NOT NULL, --ALTER CAMPO ID_DOC_ORIG para FK Tabela NOTA_FISCAL
	PARC INT NOT NULL,
	DATA_VENC DATE NOT NULL,
	DATA_PAGTO DATE,
	VALOR DECIMAL(10,2),
	CONSTRAINT FK_CP1 FOREIGN KEY (COD_EMPRESA, ID_FOR)
	REFERENCES FORNECEDORES (COD_EMPRESA, ID_FOR)
)

--Cria��o da Tabela CONDI��ES DE PAGTO
CREATE TABLE COND_PAGTO(
	COD_PAGTO INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_CP VARCHAR(50) NOT NULL
)

--Cria��o da Tabela DETALHES DE CONDI��O DE PAGTO COM PARCELA
CREATE TABLE COND_PAGTO_DET(
	COD_PAGTO INT NOT NULL,
	PARC INT NOT NULL,
	DIAS INT NOT NULL,
	PCT DECIMAL(10,2) NOT NULL, --PERCENTUAL DA PARCELA
	CONSTRAINT FK_CONDP1 FOREIGN KEY (COD_PAGTO)
	REFERENCES COND_PAGTO(COD_PAGTO)
)

--COMERCIAL
--Cria��o da Tabela PEDIDO DE VENDAS
CREATE TABLE PED_VENDAS(
	COD_EMPRESA INT NOT NULL,
	NUM_PEDIDO INT NOT NULL,
	ID_CLIENTE INT NOT NULL,
	COD_PAGTO INT NOT NULL,
	DATA_PEDIDO DATE NOT NULL,
	DATA_ENTREGA DATE NOT NULL,
	SITUACAO NCHAR(1) NOT NULL, --A=ABERTO, P=PLANEJADO, F=FINALIZADO
	TOTAL_PED DECIMAL(10,2),
	CONSTRAINT FK_PV1 FOREIGN KEY (COD_EMPRESA, ID_CLIENTE)
	REFERENCES CLIENTES (COD_EMPRESA, ID_CLIENTE),
	CONSTRAINT FK_PV2 FOREIGN KEY (COD_PAGTO)
	REFERENCES COND_PAGTO(COD_PAGTO),
	CONSTRAINT PK_PV1 PRIMARY KEY (COD_EMPRESA, NUM_PEDIDO)
)

--Cria��o da Tabela PEDIDO VENDAS ITENS
CREATE TABLE PED_VENDAS_ITENS(
	COD_EMPRESA INT NOT NULL,
	NUM_PEDIDO INT NOT NULL,
	SEQ_MAT INT NOT NULL,
	COD_MAT INT NOT NULL,
	QTD INT NOT NULL,
	VAL_UNIT DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_PVIT1 FOREIGN KEY (COD_EMPRESA, NUM_PEDIDO)
	REFERENCES PED_VENDAS (COD_EMPRESA, NUM_PEDIDO),
	CONSTRAINT PK_PVIT1 PRIMARY KEY (COD_EMPRESA, NUM_PEDIDO, SEQ_MAT)
)

--Cria��o da Tabela VENDEDORES
--DROP TABLE VENDEDORES
CREATE TABLE VENDEDORES(
	COD_EMPRESA INT NOT NULL,
	MATRICULA INT NOT NULL,
	CONSTRAINT FK_VEND1 FOREIGN KEY (COD_EMPRESA, MATRICULA)
	REFERENCES FUNCIONARIO (COD_EMPRESA, MATRICULA)
)

--Cria��o de Tabela GERENTE DE VENDAS
CREATE TABLE GERENTES(
	COD_EMPRESA INT NOT NULL,
	MATRICULA INT NOT NULL,
	CONSTRAINT FK_GER1 FOREIGN KEY (COD_EMPRESA, MATRICULA)
	REFERENCES FUNCIONARIO(COD_EMPRESA, MATRICULA)
)

--Tabela CANAL DE VENDAS GERENTE COM VNEDEDOR
CREATE TABLE CANAL_VENDAS_G_V(
	COD_EMPRESA INT NOT NULL,
	MATRICULA_GER INT NOT NULL,
	MATRICULA_VEND INT,
	CONSTRAINT FK_CGV1 FOREIGN KEY (COD_EMPRESA, MATRICULA_GER)
	REFERENCES FUNCIONARIO (COD_EMPRESA, MATRICULA),
	CONSTRAINT FK_CGV2 FOREIGN KEY (COD_EMPRESA, MATRICULA_VEND)
	REFERENCES FUNCIONARIO (COD_EMPRESA, MATRICULA),
	CONSTRAINT PK_CGV1 PRIMARY KEY (COD_EMPRESA, MATRICULA_GER, MATRICULA_VEND)
)

--CANAL DE VENDA RELACIONA VENDEDOR COM CLIENTE
CREATE TABLE CANAL_VENDAS_V_C(
	COD_EMPRESA INT NOT NULL,
	MATRICULA_VEND INT NOT NULL,
	ID_CLIENTE INT NOT NULL,
	CONSTRAINT FK_CVC1 FOREIGN KEY (COD_EMPRESA, MATRICULA_VEND)
	REFERENCES FUNCIONARIO (COD_EMPRESA, MATRICULA),
	CONSTRAINT FK_CVC2 FOREIGN KEY (COD_EMPRESA, ID_CLIENTE)
	REFERENCES CLIENTES (COD_EMPRESA, ID_CLIENTE)
)

--Cria��o da Tabela para registrar META DE VENDAS M�S A M�S/ANO
CREATE TABLE META_VENDAS(
	COD_EMPRESA INT NOT NULL,
	MATRICULA_VEND INT NOT NULL,
	ANO VARCHAR(4) NOT NULL,
	MES VARCHAR(2) NOT NULL,
	VALOR DECIMAL(10,2),
	CONSTRAINT FK_MV1 FOREIGN KEY (COD_EMPRESA, MATRICULA_VEND)
	REFERENCES FUNCIONARIO(COD_EMPRESA, MATRICULA)
)

--FISCAL
--Cria��o da Tabela dos C�DIGOS DE OPERA��ES FISCAIS
--DROP TABLE CFOP
CREATE TABLE CFOP(
	COD_CFOP VARCHAR(5) NOT NULL PRIMARY KEY,
	DESC_CFOP VARCHAR(255) NOT NULL
)

--Cria��o da Tabela NOTA_FISCAL
--DROP TABLE NOTA_FISCAL
--DROP TABLE NOTA_FISCAL_ITENS
CREATE TABLE NOTA_FISCAL(
	COD_EMPRESA INT NOT NULL,
	NUM_NF INT NOT NULL,
	TIP_NF CHAR(1) NOT NULL, --E=ENTRADA, S=SA�DA
	COD_CFOP VARCHAR(5) NOT NULL,
	ID_CLIFOR INT NOT NULL,
	COD_PAGTO INT NOT NULL,
	DATA_EMISSAO DATETIME NOT NULL,
	DATA_ENTREGA DATE NOT NULL,
	TOTAL_NF DECIMAL(10,2),
	INTEGRADA_FIN CHAR(1) DEFAULT('N'),
	INTEGRADA_SUP CHAR(1) DEFAULT('N'),
	CONSTRAINT FK_NF1 FOREIGN KEY (COD_CFOP)
	REFERENCES CFOP(COD_CFOP),
	CONSTRAINT FK_NF2 FOREIGN KEY (COD_PAGTO)
	REFERENCES COND_PAGTO (COD_PAGTO),
	CONSTRAINT PK_NF1 PRIMARY KEY (COD_EMPRESA, NUM_NF)
)

--Cria��o da Tabela NOTA_FISCAL_ITENS
CREATE TABLE NOTA_FISCAL_ITENS(
	COD_EMPRESA INT NOT NULL,
	NUM_NF INT NOT NULL,
	SEQ_MAT INT NOT NULL,
	COD_MAT INT NOT NULL,
	QTD INT NOT NULL,
	VAL_UNIT DECIMAL(10,2) NOT NULL,
	PED_ORIG INT NOT NULL,
	CONSTRAINT FK_NFIT1 FOREIGN KEY (COD_EMPRESA, NUM_NF)
	REFERENCES NOTA_FISCAL (COD_EMPRESA, NUM_NF),
	CONSTRAINT FK_NFIT2 FOREIGN KEY (COD_EMPRESA, COD_MAT)
	REFERENCES MATERIAL (COD_EMPRESA, COD_MAT)
)

--Cria��o de Tabela PAR�METRO DE INSS
CREATE TABLE PARAM_INSS(
	VIGENCIA_INI DATE,
	VIGENCIA_FIM DATE,
	VALOR_DE DECIMAL(10,2) NOT NULL,
	VALOR_ATE DECIMAL(10,2) NOT NULL,
	PCT DECIMAL(10,2)
)

--Cria��o de Tabela de PAR�METRO DO IRRF
CREATE TABLE PARAM_IRRF(
	VIGENCIA_INI DATE,
	VIGENCIA DATE,
	VALOR_DE DECIMAL(10,2) NOT NULL,
	VALOR_ATE DECIMAL(10,2) NOT NULL,
	PCT DECIMAL(10,2) NOT NULL,
	VAL_ISENT DECIMAL(10,2)
)

--Cria��o de Tabela AUDIT SAL�RIO
CREATE TABLE AUDITORIA_SALARIO(
	COD_EMPRESA INT NOT NULL,
	MATRICULA VARCHAR(30) NOT NULL,
	SAL_ANTES DECIMAL(10,2) NOT NULL,
	SAL_DEPOIS DECIMAL(10,2) NOT NULL,
	USUARIO VARCHAR(20) NOT NULL,
	DATA_ATUALIZACAO DATETIME NOT NULL
)

--Tabela de Par�metros para autonumera��o
CREATE TABLE PARAMETROS(
	COD_EMPRESA INT NOT NULL,
	PARAM VARCHAR(50) NOT NULL,
	VALOR INT NOT NULL,
	CONSTRAINT FK_PARAM1 FOREIGN KEY (COD_EMPRESA)
	REFERENCES EMPRESA(COD_EMPRESA),
	CONSTRAINT PK_PARAM1 PRIMARY KEY (COD_EMPRESA, PARAM)
)

-- CREATE INDEX IX_PARAM1 ON PARAMETROS(COD_EMPRESA, PARAM)

--ADD CAMPO LOGIN TABELA APONTAMENTOS CRIA��O AP�S TABELA USU�RIOS E FK
ALTER TABLE APONTAMENTOS ADD LOGIN VARCHAR(30) NOT NULL

--ADICIONAR CMAPO LOTE NA TABELA APONTAMENTOS
ALTER TABLE APONTAMENTOS ADD LOTE VARCHAR(20) NOT NULL

--ADD CAMPO LOGIN TABELA ESTOQUE_MOV CRIA��O AP�S TABELA USU�RIO
ALTER TABLE ESTOQUE_MOV ADD LOGIN VARCHAR(30) NOT NULL

--N�O APLICADOS EXEMPLOS
ALTER TABLE APONTAMENTOS ADD COSNTRAINT FK_APONT3
FOREIGN KEY (LOGIN) REFERENCES USUARIOS(LOGIN)

--REMOVENDO CONSTRAINT PARA TESTE
ALTER TABLE CONSUMO DROP CONSTRAINT FK_CONS2
ALTER TABLE APONTAMENTOS DROP CONSTRAINT FK_APONT3

ALTER TABLE ESTOQUE_MOV ADD CONSTRAINT FK_ESTM2
FOREIGN KEY (LOGIN) REFERENCES USUARIOS(LOGIN)

--REMOVENDO FK LOGIN PARA TESTES
ALTER TABLE ESTOQUE_MOV DROP CONSTRAINT FK_ESTM2

--ALTERAR COD_PAGTO TAB PED_COMPRAS PARA FOREIGN KEY AP�S TABELA COND_PAGTO
ALTER TABLE PED_COMPRAS ADD
FOREIGN KEY (COD_PAGTO) REFERENCES COND_PAGTO (COD_PAGTO)

--ALTERARA TABELA CONTAS_RECEBER CAMPO ID_DOC_ORIG PARA FK TABELA NOTA_FISCAL
ALTER TABLE CONTAS_RECEBER ADD
FOREIGN KEY (COD_PAGTO) REFERENCES COND_PAGTO (COD_PAGTO)

--ALTERAR TABELA CONTAS_RECEBER CAMPO ID_DOC_ORIG PARA FK TABELA NOTA_FISCAL
ALTER TABLE CONTAS_RECEBER ADD
FOREIGN KEY (ID_DOC_ORIG) REFERENCES NOTA_FISCAL (NUM_UF)

--ALTERAR TABELA CONTAS_PAGAR CAMPO ID_DOC_ORIG PARA FK TABELA NOTA_FISCAL
ALTER TABLE CONTAS_PAGAR ADD
FOREIGN KEY (ID_DOC_ORIG) REFERENCES NOTA_FISCAL (NUM_UF)