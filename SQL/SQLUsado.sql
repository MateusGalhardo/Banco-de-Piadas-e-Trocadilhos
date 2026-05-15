create table Classificacoes (
    Id int identity (1,1) primary key,
    classificacao nvarchar (20) not null unique
)

insert into Classificacoes (classificacao)
values ('Livre'), ('12+'), ('16+'), ('18+')


create table Piadas (
    piadaId int identity(1,1) primary key,
    texto nvarchar(800) NOT NULL,
    categoria nvarchar(100) NOT NULL, 
    tipo nvarchar(50) NOT NULL,
    classificacaoId int NOT NULL,
    dataPiada datetime2 default getdate(),

    constraint uq_piadas_texto unique (texto),

    constraint fk_piadas_classificacao
        foreign key (classificacaoId)
        references Classificacoes(Id)
)
