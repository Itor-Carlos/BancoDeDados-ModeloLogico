DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TYPE tipo_pessoa AS ENUM('fisica','juridica');

CREATE TABLE Pessoa (
    documento INT PRIMARY KEY,
    primeiro_nome VARCHAR(30),
    segundo_nome VARCHAR(30), 
    telefones VARCHAR[]
);

CREATE TABLE Endereco(
    cep INT NOT NULL,
    Pessoa_documento INT NOT NULL,
    numero INT NOT NULL,
    complemento VARCHAR(45) NULL,
    bairro VARCHAR(45) NOT NULL,
    rua VARCHAR(45) NOT NULL,
    PRIMARY KEY(cep, Pessoa_documento), 
    FOREIGN KEY (Pessoa_documento) REFERENCES Pessoa(documento)
);

CREATE TABLE Funcionario (
    Pessoa_documento INT NOT NULL,
    data_nascimento DATE,
    idade INT NOT NULL,
    data_admissao DATE NOT NULL,
	salario FLOAT NOT NULL,
	PRIMARY KEY(Pessoa_documento),
    FOREIGN KEY (Pessoa_documento) REFERENCES Pessoa(documento)
);

CREATE TABLE Fornecedor(
    Pessoa_documento INT NOT NULL,
	nome_fantasia VARCHAR(50),
	email VARCHAR(45) NOT NULL,
	PRIMARY KEY(Pessoa_documento),
    FOREIGN KEY (Pessoa_documento) REFERENCES Pessoa(documento)
);

CREATE TABLE Cliente(
    Pessoa_documento INT NOT NULL,
	nome_fantasia VARCHAR(50),
	tipo tipo_pessoa,
	PRIMARY KEY(Pessoa_documento),
    FOREIGN KEY (Pessoa_documento) REFERENCES Pessoa(documento)
);

CREATE TABLE Transacao (
	idTransacao INT NOT NULL,
	valor FLOAT NOT NULL,
	data TIMESTAMP NOT NULL,
	Fornecedor_Pessoa_documento INT NULL,
	Cliente_Pessoa_Documento INT NULL,
	PRIMARY KEY (idTransacao),
	FOREIGN KEY (Fornecedor_Pessoa_documento) REFERENCES Fornecedor(Pessoa_documento),
	FOREIGN KEY (Cliente_Pessoa_documento) REFERENCES Cliente(Pessoa_documento)
);


CREATE TABLE Produto(
	id_produto INT NOT NULL,
	nome_produto VARCHAR(45) NOT NULL,
	PRIMARY KEY (id_produto)
);

CREATE TABLE Grao(
	id_grao INT,
	Produto_id_produto INT NOT NULL,
	tipo_grao VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_grao),
	FOREIGN KEY (Produto_id_produto) REFERENCES Produto(id_produto) 
);

CREATE TABLE Fertilizante (
	idFertilizante INT,
	Produto_id_produto INT NOT NULL,
	nome_produto VARCHAR(45) NOT NULL,
	validade TIMESTAMP NOT NULL,
	PRIMARY KEY (idFertilizante),
	FOREIGN KEY (Produto_id_produto) REFERENCES Produto(id_produto)
);

CREATE TABLE Fertilizante_has_Transacao(
	quantidade INT NOT NULL,
	Fertilizante_idFertilizante INT,
	Transacao_idTransacao INT,
	PRIMARY KEY (Fertilizante_idFertilizante, Transacao_idTransacao),
	FOREIGN KEY (Fertilizante_idFertilizante) REFERENCES Fertilizante(idFertilizante),
	FOREIGN KEY (Transacao_idTransacao) REFERENCES Transacao(idTransacao)
);

CREATE TABLE Silo (
	id_silo INT,
	cheio BOOLEAN NOT NULL DEFAULT (false),
	capacidade INT,
	PRIMARY KEY (id_silo)
);

CREATE TABLE Silo_has_Grao (
	Silo_id_silo INT,
	Grao_id_grao INT,
	PRIMARY KEY (Silo_id_silo, Grao_id_grao),
	FOREIGN KEY (Silo_id_silo) REFERENCES Silo (id_silo),
	FOREIGN KEY (Grao_id_grao) REFERENCES Grao (id_grao)
);


SELECT * FROM Silo_has_Grao;
