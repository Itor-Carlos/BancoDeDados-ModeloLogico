CREATE TYPE nome AS (
	primeiro_nome VARCHAR(30),
	sobrenome VARCHAR(30)
);

CREATE TABLE Pessoa (
    documento VARCHAR(20) PRIMARY KEY,
    nome nome, 
    telefones VARCHAR(20)[]
);

CREATE TABLE Funcionario (
    documento VARCHAR(20) PRIMARY KEY,
    nome nome,
    telefones VARCHAR(20)[],
    data_nascimento DATE,
    idade INT,
    data_admissao DATE,
    FOREIGN KEY (documento) REFERENCES Pessoa(documento)
);

CREATE TABLE Fornecedor(
    documento VARCHAR(20) PRIMARY KEY,
    nome nome,
    telefones VARCHAR(20)[],
	nome_fantasia VARCHAR(50),
    FOREIGN KEY (documento) REFERENCES Pessoa(documento)
);