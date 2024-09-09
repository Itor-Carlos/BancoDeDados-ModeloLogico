DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TYPE status_galpao AS ENUM('vazio','cheio','utilizado');

CREATE TABLE IF NOT EXISTS Pessoa(
    documento INT NOT NULL,
    primeiro_nome VARCHAR(30) NOT NULL,
    segundo_nome VARCHAR(30) NOT NULL, 
    telefones VARCHAR[] NOT NULL,
	PRIMARY KEY(documento)
);

CREATE TABLE IF NOT EXISTS Endereco(
    cep INT NOT NULL,
    Pessoa_documento INT NOT NULL,
    numero INT NOT NULL,
    complemento VARCHAR(45) NULL,
    bairro VARCHAR(45) NOT NULL,
    rua VARCHAR(45) NOT NULL,
    PRIMARY KEY(cep, Pessoa_documento), 
    FOREIGN KEY (Pessoa_documento) REFERENCES Pessoa(documento)
);

CREATE TABLE IF NOT EXISTS Funcionario (
    Pessoa_documento INT NOT NULL,
    data_nascimento DATE NOT NULL,
    idade INT NOT NULL,
    data_admissao DATE NOT NULL,
	salario FLOAT NOT NULL,
	PRIMARY KEY(Pessoa_documento),
    FOREIGN KEY (Pessoa_documento) REFERENCES Pessoa(documento)
);

CREATE TABLE IF NOT EXISTS Fornecedor(
    Pessoa_documento INT NOT NULL,
	nome_fantasia VARCHAR(50) NOT NULL,
	email VARCHAR(45) NOT NULL,
	PRIMARY KEY(Pessoa_documento),
    FOREIGN KEY (Pessoa_documento) REFERENCES Pessoa(documento)
);

CREATE TABLE IF NOT EXISTS Cliente(
    Pessoa_documento INT NOT NULL,
	nome_fantasia VARCHAR(50) NOT NULL,
	email VARCHAR(45) NOT NULL,
	PRIMARY KEY(Pessoa_documento),
    FOREIGN KEY (Pessoa_documento) REFERENCES Pessoa(documento)
);

CREATE TABLE IF NOT EXISTS Transacao(
	idTransacao INT NOT NULL,
	valor FLOAT NOT NULL,
	data TIMESTAMP NOT NULL,
	Fornecedor_Pessoa_documento INT NULL,
	Cliente_Pessoa_Documento INT NULL,
	PRIMARY KEY (idTransacao),
	FOREIGN KEY (Fornecedor_Pessoa_documento) REFERENCES Fornecedor(Pessoa_documento),
	FOREIGN KEY (Cliente_Pessoa_documento) REFERENCES Cliente(Pessoa_documento)
);


CREATE TABLE IF NOT EXISTS Produto(
	id_produto INT NOT NULL,
	nome_produto VARCHAR(45) NOT NULL,
	PRIMARY KEY (id_produto)
);

CREATE TABLE IF NOT EXISTS Grao(
	id_grao INT NOT NULL,
	Produto_id_produto INT NOT NULL,
	tipo_grao VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_grao),
	FOREIGN KEY (Produto_id_produto) REFERENCES Produto(id_produto) 
);

CREATE TABLE IF NOT EXISTS Fertilizante(
	idFertilizante INT NOT NULL,
	Produto_id_produto INT NOT NULL,
	nome_produto VARCHAR(45) NOT NULL,
	validade TIMESTAMP NOT NULL,
	PRIMARY KEY (idFertilizante),
	FOREIGN KEY (Produto_id_produto) REFERENCES Produto(id_produto)
);

CREATE TABLE IF NOT EXISTS Fertilizante_has_Transacao(
	quantidade INT NOT NULL,
	Fertilizante_idFertilizante INT NULL,
	Transacao_idTransacao INT NULL,
	PRIMARY KEY (Fertilizante_idFertilizante, Transacao_idTransacao),
	FOREIGN KEY (Fertilizante_idFertilizante) REFERENCES Fertilizante(idFertilizante),
	FOREIGN KEY (Transacao_idTransacao) REFERENCES Transacao(idTransacao)
);

CREATE TABLE IF NOT EXISTS Silo(
	id_silo INT NOT NULL,
	cheio BOOLEAN NOT NULL DEFAULT (false),
	capacidade INT NOT NULL,
	PRIMARY KEY (id_silo)
);

CREATE TABLE IF NOT EXISTS Silo_has_Grao(
	Silo_id_silo INT NOT NULL,
	Grao_id_grao INT NOT NULL,
	PRIMARY KEY (Silo_id_silo, Grao_id_grao),
	FOREIGN KEY (Silo_id_silo) REFERENCES Silo (id_silo),
	FOREIGN KEY (Grao_id_grao) REFERENCES Grao (id_grao)
);


CREATE TABLE IF NOT EXISTS Area(
	id_area INT NOT NULL,
	tamanho_hectar FLOAT NOT NULL,
	localizacao VARCHAR(45) NOT NULL,
	colheita_disponivel BOOLEAN NOT NULL,
	PRIMARY KEY(id_area)
);

CREATE TABLE IF NOT EXISTS Silo_localizado(
	Silo_id_silo INT NOT NULL,
	Area_id_area INT NOT NULL,
	PRIMARY KEY(Silo_id_silo, Area_id_area),
	FOREIGN KEY(Silo_id_silo) REFERENCES Silo(id_silo),
	FOREIGN KEY(Area_id_area) REFERENCES Area(id_area)
);

CREATE TABLE IF NOT EXISTS Galpao(
	id_galpao INT NOT NULL,
	capacidade FLOAT NOT NULL,
	status status_galpao NOT NULL,
	PRIMARY KEY(id_galpao)
);

CREATE TABLE IF NOT EXISTS Tipo_Maquinario(
	id_tipo_maquinario INT NOT NULL,
	nome_maquinario VARCHAR(45) NOT NULL,
	PRIMARY KEY(id_tipo_maquinario)
);

CREATE TABLE IF NOT EXISTS Envio_Carga(
	id_envio_carga INT,
	destino VARCHAR(45) NOT NULL,
	data_envio DATE,
	PRIMARY KEY(id_envio_carga)
);

CREATE TABLE IF NOT EXISTS Maquinario(
    id_maquinario INT NOT NULL,
    tipo_maquinario VARCHAR(45) NOT NULL,
    id_tipo_maquinario INT NOT NULL,
    PRIMARY KEY(id_maquinario),
    CONSTRAINT unique_maquinario_tipo UNIQUE (id_maquinario, id_tipo_maquinario),
    FOREIGN KEY (id_tipo_maquinario) REFERENCES Tipo_Maquinario(id_tipo_maquinario)
);

CREATE TABLE IF NOT EXISTS EnvioCarga_has_Maquinario(
    id_envio_carga INT NOT NULL,
    Maquina_id_maquinario INT NOT NULL,
    id_tipo_maquinario INT NOT NULL,
    PRIMARY KEY(id_envio_carga, Maquina_id_maquinario, id_tipo_maquinario),
    FOREIGN KEY(id_envio_carga) REFERENCES Envio_Carga(id_envio_carga),
    FOREIGN KEY(Maquina_id_maquinario, id_tipo_maquinario) REFERENCES Maquinario (id_maquinario, id_tipo_maquinario)
);

CREATE TABLE IF NOT EXISTS Manutencoes(
    id_manutencao INT NOT NULL,
    Maquinario_id_maquinario INT NOT NULL,
    id_tipo_maquinario INT NOT NULL,
    data_manutencao TIMESTAMP NOT NULL,
    descricao_manutencao VARCHAR(45) NULL,
    PRIMARY KEY (id_manutencao, Maquinario_id_maquinario, id_tipo_maquinario),
    FOREIGN KEY (Maquinario_id_maquinario , id_tipo_maquinario) REFERENCES Maquinario(id_maquinario , id_tipo_maquinario)
);

CREATE TABLE IF NOT EXISTS Saca (
	id_saca INT NOT NULL,
	peso FLOAT NOT NULL,
	EnvioCarga_id_envio_carga INT NOT NULL,
  	Area_id_area INT NOT NULL,
	PRIMARY KEY (id_saca),
	FOREIGN KEY (Area_id_area) REFERENCES Area (id_area),
	UNIQUE(id_saca, EnvioCarga_id_envio_carga, Area_id_area) -- Chave única
);


CREATE TABLE IF NOT EXISTS Galpao_has_Saca (
  Galpao_id_galpao INT NOT NULL,
  Saca_id_saca INT NOT NULL,
  PRIMARY KEY (Galpao_id_galpao, Saca_id_saca),
  FOREIGN KEY (Galpao_id_galpao) REFERENCES Galpao(id_galpao),
  FOREIGN KEY (Saca_id_saca) REFERENCES Saca(id_saca)
);

CREATE TABLE IF NOT EXISTS Transacao_has_Saca (
  Transacao_idTransacao INT NULL,
  Saca_id_saca INT NULL,
  PRIMARY KEY (Transacao_idTransacao, Saca_id_saca),
  FOREIGN KEY (Transacao_idTransacao) REFERENCES Transacao (idTransacao),
  FOREIGN KEY (Saca_id_saca) REFERENCES Saca (id_saca)
);

CREATE TABLE IF NOT EXISTS EnvioCarga_has_Saca (
  EnvioCarga_id_envio_carga INT NOT NULL,
  Saca_id_saca INT NOT NULL,
  PRIMARY KEY (EnvioCarga_id_envio_carga, Saca_id_saca),
  FOREIGN KEY (EnvioCarga_id_envio_carga) REFERENCES Envio_carga (id_envio_carga),
  FOREIGN KEY (Saca_id_saca) REFERENCES Saca (id_saca)
);
