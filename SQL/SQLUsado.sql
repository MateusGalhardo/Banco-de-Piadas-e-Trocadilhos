CREATE TABLE Classificacoes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    classificacao NVARCHAR(20) NOT NULL UNIQUE
)

INSERT INTO Classificacoes (classificacao)
VALUES ('Livre'), ('12+'), ('16+'), ('18+')


create table Piadas (
    piadaId int identity(1,1) primary key,
    texto nvarchar(800) NOT NULL,
    categoria nvarchar(100) NOT NULL, 
    tipo nvarchar(50) NOT NULL,
    classificacaoId int NOT NULL,
    dataPiada DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT uq_piadas_texto UNIQUE (texto),

    CONSTRAINT fk_piadas_classificacao
        FOREIGN KEY (classificacaoId)
        REFERENCES Classificacoes(Id)
)
