CREATE TYPE nome AS (
	primeiro_nome VARCHAR(30),
	sobrenome VARCHAR(30)
);

CREATE TABLE Pessoa (
    documento VARCHAR(20) PRIMARY KEY,
    nome nome, 
    telefones VARCHAR(20)[]
);
