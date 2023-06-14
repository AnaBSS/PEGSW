Create DataBase cm1
Go
Use cm1
Go

CREATE TABLE usuario(
email	VARCHAR(100) NOT NULL,
senha	VARBINARY(64) NOT NULL, 
tipo	CHAR(1)
PRIMARY KEY (email)
)

GO
Create TABLE Especialidade (
codigo		INT				NOT NULL,
nome		VARCHAR(50)		NOT NULL
PRIMARY KEY(codigo)
)
Go
Create Table Gestor (
cpf			CHAR(11) CHECK(LEN (cpf)= 11) NOT NULL,
nome		VARCHAR(100)				  NOT NULL,
email		VARCHAR(100)				  NOT NULL,
telefone	CHAR(11)					  NOT NULL,
tipo		CHAR(1)						NOT NULL,
senha		VARCHAR(50)                 NOT NULL
PRIMARY KEY(cpf)
)
Go
Create Table Medico (
cpf 			CHAR(11) CHECK(LEN (cpf)= 11) NOT NULL,
nome			VARCHAR(100)				  NOT NULL,
crm				CHAR(6)						  NOT NULL,
tipo			CHAR(1)						  NOT NULL,
especialidade	INT     					  NOT NULL,
email			VARCHAR(100)				  NOT NULL,
telefone		CHAR(11)					  NOT NULL,
senha_hash      VARBINARY(64)                 NOT NULL
PRIMARY KEY(crm)
FOREIGN KEY (especialidade) references Especialidade (codigo)
)
GO
Create Table Atendente (
cpf			CHAR(11) CHECK(LEN (cpf)= 11) NOT NULL,
nome		VARCHAR(100)				  NOT NULL,
tipo		CHAR(1)							  NOT NULL,
email		VARCHAR(100)				  NOT NULL,
telefone	CHAR(11)					  NOT NULL,
senha		VARCHAR(64)                 NOT NULL
Primary Key (cpf)
)
GO
Create Table Paciente (
cpf				CHAR(11) CHECK(LEN (cpf)= 11) NOT NULL,
nome			VARCHAR(100)				  NOT NULL,
cartao_sus	    CHAR(15)					  NOT NULL,
dataNasc		DATE						  NOT NULL,
email			VARCHAR(100)				  NOT NULL,
telefone		CHAR(11)					  NOT NULL,
genero			VARCHAR(10)					  NOT NULL,
tipoSangue		VARCHAR(3)					  NOT NULL,
peso			DECIMAL(4,1)				  NOT NULL,
altura			INT         				  NOT NULL,
senha_hash      VARBINARY(64)                 NOT NULL
PRIMARY KEY(cpf)
)
GO
Create Table Prontuario (
codigo			INT				NOT NULL,
cpf				CHAR(11)		NOT NULL,
crm				CHAR(6)			NOT NULL,
diagnostico		VARCHAR(255)	NOT NULL
PRIMARY KEY(codigo),
FOREIGN KEY (crm)	 references Medico(crm),
FOREIGN KEY (cpf)  references Paciente(cpf)
)
 GO
Create Table Consulta (
codigo			INT			 NOT NULL,
especialidade	INT			 NOT NULL,
crm				CHAR(6)		 NOT NULL,
cpf				CHAR(11)	 NOT NULL,
data     		DATE       	 NOT NULL,
hora			TIME		 NOT NULL
PRIMARY KEY(codigo),
FOREIGN KEY (crm)	 references Medico(crm),
FOREIGN KEY (cpf)  references Paciente(cpf),
FOREIGN KEY (especialidade)	 references Especialidade(codigo),
)
--ESPECIALIDADES
GO
Insert Into Especialidade Values
(1, 'Cardiologia'),
(2, 'Dermatologia'),
(3,'Ginecologia'),
(4, 'Fisioterapia'),
(5, 'Ortopedia'),
(6, 'Oftalmologia'),
(7, 'Neurologia'),
(8, 'Psiquiatria'),
(9, 'Endocrinologia'),
(10, 'Urologia')

-- DECLARANDO SENHA E INSERINDO GESTOR
GO
DECLARE @senha VARCHAR(50) = '123456'
DECLARE @senha_hash VARBINARY(64) = HASHBYTES('SHA2_256', @senha)
GO
INSERT INTO Gestor (cpf, nome, email, telefone, tipo, senha)
VALUES ('12345678998', 'Gestor', 'gestor@hw.com', '11987361671', 'G','123456')

SELECT * FROM GESTOR

select * from usuario
select * from Atendente

--------------------------------------------------- INÍCIO PROCEDURES E FUNÇÕES (LOGIN) ---------------------------------------------
--procedure que cria os usuarios do sistema
CREATE PROCEDURE sp_criptografaSenha(@email VARCHAR(50), @senha VARCHAR(50), @tipo CHAR(1))
AS
	DECLARE @senha_hash VARBINARY(64) = HASHBYTES('SHA2_256', @senha)
BEGIN
	INSERT INTO usuario VALUES(@email, @senha_hash, @tipo)
END

--testando a procedure de criptografar senha
EXEC sp_criptografaSenha 'gestor@hw.com', '123456', 'G'

--function que valida o login
CREATE FUNCTION fn_validaLogin(@email VARCHAR(100), @senha VARCHAR(50))
RETURNS @login TABLE  (
tipo char(1)
)
AS
BEGIN
	DECLARE @senha_hash VARBINARY(64) = HASHBYTES('SHA2_256', @senha),
			@tipo CHAR(1)
	
	SET @tipo = (SELECT tipo FROM usuario WHERE email = @email AND senha = @senha_hash)

	INSERT INTO @login VALUES (@tipo)
RETURN
END

SELECT * FROM fn_validaLogin('gestor@hw.com', '123456')

--------------------------------------------------- PROCEDURES E FUNÇÕES (GESTOR) ---------------------------------------------
--procedure gestor mantendo funcionarios (Atendente) (CREATE, UPDATE, DELETE)
GO
CREATE PROCEDURE sp_manter_atendente (@opcao CHAR(1), @cpf CHAR(11), @nome VARCHAR(100), @tipo CHAR(1), @email VARCHAR(100), @telefone CHAR(11), @senha VARCHAR(50), @saida VARCHAR(250) OUTPUT
)
AS
BEGIN
  IF (UPPER(@opcao) = 'D' AND @cpf IS NOT NULL AND @email IS NOT NULL)
  BEGIN
	DELETE FROM usuario WHERE email = @email
    DELETE FROM Atendente WHERE cpf = @cpf;
    SET @saida = 'Atendente com o cpf: ' + CAST(@cpf AS VARCHAR(15)) + ' excluído'
  END
  ELSE
  BEGIN
    IF (UPPER(@opcao) = 'D' AND @cpf IS NULL)
    BEGIN
      RAISERROR('Atendente não encontrado', 16, 1)
    END
    ELSE
    BEGIN
      IF (UPPER(@opcao) = 'I')
      BEGIN
        
        INSERT INTO Atendente (cpf, nome, tipo, email, telefone, senha)
        VALUES (@cpf, @nome, @tipo, @email, @telefone, @senha)

		EXEC sp_criptografaSenha @email, @senha, 'A'
        
        SET @saida = 'Atendente cadastrado'
      END
      ELSE
      BEGIN
        IF (UPPER(@opcao) = 'U')
        BEGIN
          UPDATE Atendente
          SET cpf = @cpf, nome = @nome, tipo = @tipo, email = @email, telefone = @telefone, senha = @senha
          WHERE cpf = @cpf;

		  DELETE FROM usuario WHERE email = @email

		  EXEC sp_criptografaSenha @email, @senha, 'A'
          
          SET @saida = 'Atendente com o cpf: ' + CAST(@cpf AS VARCHAR(15)) + ' atualizado'
        END
        ELSE
        BEGIN
          RAISERROR('Operação Inválida', 16, 1)
        END
      END
    END
  END
END

-- TESTANDO A PROCEDURE ACIMA
GO
DECLARE @saida1 VARCHAR(MAX)
DECLARE @senha VARCHAR(50) = '123456'
EXEC sp_manter_atendente 'I', '62251856820', 'Tereza Alves', 'A', 'tereza@gmail.com', '11985266471', @senha, @saida1 OUTPUT
PRINT @saida1
GO
DECLARE @saida2 VARCHAR(MAX)
DECLARE @senha VARCHAR(50) = '123456'
EXEC sp_manter_atendente 'I', '88711694840', 'Miguel Melo', 'A', 'miguel@gmail.com', '11991576630', @senha, @saida2 OUTPUT
PRINT @saida2

SELECT * FROM ATENDENTE




--function GESTOR LISTANDO ATENDENTE (não está listando em ordem alfabética)
GO
Create function fn_listaratendente()
Returns @table Table (
cpf char(11),
nome varchar(100),
tipo varchar(1),
email varchar(100),
telefone char(11)
)
AS
Begin 
	Insert Into @table(cpf, nome, tipo, email, telefone)
	Select cpf, nome, tipo, email, telefone From Atendente
	Order By nome Asc
Return
End

Select * From fn_listaratendente()

--function GESTOR PESQUISANDO ATENDENTE POR CPF
GO
CREATE FUNCTION fn_pesquisaratendente(@cpf CHAR(11))
RETURNS @table TABLE (
    cpf CHAR(11),
    nome VARCHAR(100),
    tipo VARCHAR(1),
    email VARCHAR(100),
    telefone CHAR(11)
)
AS
BEGIN
    INSERT INTO @table (cpf, nome, tipo, email, telefone)
    SELECT cpf, nome, tipo, email, telefone
    FROM Atendente 
    WHERE cpf = @cpf
    ORDER BY nome ASC

    RETURN
END

SELECT * FROM fn_pesquisaratendente('62251856820')


-- PROCEDURE DO GESTOR MANTENDO MÉDICO (CREATE, UPDATE, DELETE)
GO
CREATE PROCEDURE sp_manter_medico (@opcao CHAR(1), @cpf CHAR(11), @nome VARCHAR(100), @crm CHAR(6), @tipo CHAR(1), @especialidade INT, @email VARCHAR(100), @telefone CHAR(11), @senha VARCHAR(50), @saida VARCHAR(250) OUTPUT)
AS
BEGIN
  IF (UPPER(@opcao) = 'D' AND @crm IS NOT NULL)
  BEGIN
    DELETE FROM Medico WHERE crm = @crm;
    SET @saida = 'Médico com o CRM: ' + CAST(@crm AS VARCHAR(15)) + ' excluído'
  END
  ELSE
  BEGIN
    IF (UPPER(@opcao) = 'D' AND @crm IS NULL)
    BEGIN
      RAISERROR('Médico não encontrado', 16, 1)
    END
    ELSE
    BEGIN
      IF (UPPER(@opcao) = 'I')
      BEGIN
        DECLARE @senha_hash VARBINARY(64) = HASHBYTES('SHA2_256', @senha)
        
        INSERT INTO Medico (cpf, nome, crm, tipo, especialidade, email, telefone, senha_hash)
        VALUES (@cpf, @nome, @crm, @tipo, @especialidade, @email, @telefone, @senha_hash)
        
        SET @saida = 'Médico cadastrado'
      END
      ELSE
      BEGIN
        IF (UPPER(@opcao) = 'U')
        BEGIN
          UPDATE Medico
          SET cpf = @cpf, nome = @nome, crm = @crm, tipo = @tipo, especialidade = @especialidade, email = @email, telefone = @telefone
          WHERE crm = @crm;
          
          SET @saida = 'Médico com o CRM: ' + CAST(@crm AS VARCHAR(15)) + ' atualizado'
        END
        ELSE
        BEGIN
          RAISERROR('Operação Inválida', 16, 1)
        END
      END
    END
  END
END
--TESTANDO A PROCEDURE ACIMA
GO
DECLARE @saida1 VARCHAR(MAX)
DECLARE @senha VARCHAR(50) = '123456'
EXEC sp_manter_medico 'I', '10502942894', 'Dr. Hans Chucrute', '987654', 'M', '4', 'drhc@gmail.com', '11970707070', @senha, @saida1 OUTPUT
PRINT @saida1
GO
DECLARE @saida2 VARCHAR(MAX)
DECLARE @senha VARCHAR(50) = '123456'
EXEC sp_manter_medico 'I', '83572980879', 'Dr. Fernanda Caldeira', '456789', 'M', '1', 'drfc@gmail.com', '11911223344', @senha, @saida2 OUTPUT
PRINT @saida2

SELECT * FROM MEDICO

--function GESTOR LISTANDO MÉDICO
Go
Create function fn_listarmedico()
Returns @table Table (
cpf char(11),
nome varchar(100),
crm char(6),
tipo varchar(1),
especialidade varchar(20),
email varchar(100),
telefone char(11)
)
AS
Begin 
	Insert Into @table(cpf, nome, crm, tipo, especialidade, email, telefone)
	Select m.cpf, m.nome, m.crm, m.tipo, e.nome, m.email, m.telefone From Medico m, Especialidade e
	WHERE m.especialidade = e.codigo
	Order By m.nome Asc
Return
End

SELECT * FROM fn_listarmedico()


--function GESTOR PESQUISANDO MÉDICO POR CRM
GO
CREATE FUNCTION fn_pesquisarmedico(@crm CHAR(6))
RETURNS @table TABLE (
    crm CHAR(6),
    nome VARCHAR(100),
	cpf CHAR(11),
    tipo VARCHAR(1),
    especialidade VARCHAR(20),
    email VARCHAR(100),
    telefone CHAR(11)
)
AS
BEGIN
    INSERT INTO @table (cpf, nome, crm, tipo, especialidade, email, telefone)
    SELECT m.cpf, m.nome, m.crm, m.tipo, e.nome, m.email, m.telefone
    FROM Medico m
    JOIN Especialidade e ON m.especialidade = e.codigo
    WHERE m.crm = @crm
    ORDER BY m.nome ASC

    RETURN
END

SELECT * FROM fn_pesquisarmedico('987654')

--------------------------------------------------- FIM PROCEDURES E FUNÇÕES (GESTOR) ---------------------------------------------------

--------------------------------------------------- INÍCIO PROCEDURES E FUNÇÕES (ATENDENTE) ---------------------------------------------
-- procedure ATENDENTE MANTENDO PACIENTE (CREATE, UPDATE, DELETE)
GO
CREATE PROCEDURE sp_manter_paciente (@opcao CHAR(1), @cpf CHAR(11), @nome VARCHAR(100), @cartao_sus CHAR(15), @data DATE, @email VARCHAR(100), @telefone CHAR(11), @genero VARCHAR(10), @tipoSangue VARCHAR(3), @peso DECIMAL(4,1), @altura INT, @senha VARCHAR(50), @saida VARCHAR(300) OUTPUT)
AS
BEGIN
  IF (UPPER(@opcao) = 'D' AND @cpf IS NOT NULL)
  BEGIN
    DELETE FROM Paciente WHERE cpf = @cpf;
    SET @saida = 'Paciente com o CPF: ' + CAST(@cpf AS VARCHAR(11)) + ' excluído';
  END
  ELSE
  BEGIN
    IF (UPPER(@opcao) = 'D' AND @cpf IS NULL)
    BEGIN
      RAISERROR('Paciente não encontrado', 16, 1);
    END
    ELSE
    BEGIN
      IF (UPPER(@opcao) = 'I')
      BEGIN
        DECLARE @senha_hash VARBINARY(64) = HASHBYTES('SHA2_256', @senha);
        
        INSERT INTO Paciente (cpf, nome, cartao_sus, dataNasc, email, telefone, genero, tipoSangue, peso, altura, senha_hash)
        VALUES (@cpf, @nome, @cartao_sus, @data, @email, @telefone, @genero, @tipoSangue, @peso, @altura, @senha_hash);
        
        SET @saida = 'Paciente cadastrado';
      END
      ELSE
      BEGIN
        IF (UPPER(@opcao) = 'U')
        BEGIN
          UPDATE Paciente
          SET cpf = @cpf, nome = @nome, dataNasc = @data, email = @email,
              telefone = @telefone, genero = @genero, tipoSangue = @tipoSangue,
              peso = @peso, altura = @altura
          WHERE cpf = @cpf;
          
          SET @saida = 'Paciente com o CPF: ' + CAST(@cpf AS VARCHAR(11)) + ' atualizado';
        END
        ELSE
        BEGIN
          RAISERROR('Operação Inválida', 16, 1);
        END
      END
    END
  END
END

--TESTANDO A PROCEDURE ACIMA
GO
DECLARE @saida1 VARCHAR(MAX)
DECLARE @senha VARCHAR(50) = '123456'
EXEC sp_manter_paciente 'I', '04488308848', 'Neymar JR.', '122053280290004', '05/02/1992', 'neymar@gmail.com', '11988261960', 'Masculino', 'O+', 68, 175, @senha, @saida1 OUTPUT
PRINT @saida1
GO
DECLARE @saida1 VARCHAR(MAX)
DECLARE @senha VARCHAR(50) = '123456'
EXEC sp_manter_paciente 'I', '39340987896', 'Raquel Araújo', '280631238630001', '27/05/1993', 'raquel@gmail.com', '11982559557', 'Feminino', 'AB-', 59, 165, @senha, @saida1 OUTPUT
PRINT @saida1

SELECT * FROM Paciente

--function	ATENDENTE LISTANDO PACIENTE
GO
CREATE FUNCTION fn_listarpaciente()
RETURNS @table TABLE (
  cpf CHAR(11),
  nome VARCHAR(100),
  cartaoSus VARCHAR(15),
  dataNasc DATE,
  email VARCHAR(50),
  telefone CHAR(11),
  genero VARCHAR(10),
  tipoSangue VARCHAR(3),
  peso DECIMAL(4,1),
  altura INT
)
AS
BEGIN
  INSERT INTO @table (cpf, nome, cartaoSus, dataNasc, email, telefone, genero, tipoSangue, peso, altura)
  SELECT cpf, UPPER(nome) AS nome, cartao_sus, CONVERT(VARCHAR(10), dataNasc, 103) AS data , email, telefone, UPPER(genero), tipoSangue, peso, altura
  FROM Paciente
  ORDER BY nome ASC
  RETURN
END

SELECT * FROM fn_listarpaciente()

--function ATENDENTE PESQUISANDO PACIENTE POR CPF
CREATE FUNCTION fn_pesquisarpaciente(@cpf CHAR(11))
RETURNS @table TABLE (
  cpf CHAR(11),
  nome VARCHAR(100),
  cartaoSus VARCHAR(15),
  dataNasc DATE,
  email VARCHAR(50),
  telefone CHAR(11),
  genero VARCHAR(10),
  tipoSangue VARCHAR(3),
  peso DECIMAL(4,1),
  altura INT
)
AS
BEGIN
  INSERT INTO @table (cpf, nome, cartaoSus, dataNasc, email, telefone, genero, tipoSangue, peso, altura)
  SELECT cpf, UPPER(nome) AS nome, cartao_sus, dataNasc, email, telefone, UPPER(genero), tipoSangue, peso, altura
  FROM Paciente
  WHERE cpf = @cpf
  ORDER BY nome ASC
  RETURN
END

SELECT * FROM fn_pesquisarpaciente('04488308848')



--procedure ATENDENTE MANTENDO CONSULTA (CREATE, UPDATE, DELETE)
GO
CREATE PROCEDURE sp_manter_consulta (@opcao CHAR(1), @codigo INT, @especialidade INT, @crm CHAR(6), @cpf CHAR(11), @data VARCHAR(10), @hora VARCHAR(5), @saida VARCHAR(300) OUTPUT
)
AS
BEGIN
  IF (UPPER(@opcao) = 'D' AND @codigo IS NOT NULL)
  BEGIN
    DELETE FROM Consulta WHERE codigo = @codigo;
    SET @saida = 'Consulta com o código: ' + CAST(@codigo AS VARCHAR(15)) + ' excluída';
  END
  ELSE
  BEGIN
    IF (UPPER(@opcao) = 'D' AND @codigo IS NULL)
    BEGIN
      RAISERROR('Consulta não encontrada', 16, 1);
    END
    ELSE
    BEGIN
      IF (UPPER(@opcao) = 'I')
      BEGIN
        DECLARE @data_converted DATE = CONVERT(DATE, @data, 103);
        DECLARE @hora_converted TIME = CONVERT(TIME, @hora);

        INSERT INTO Consulta (codigo, especialidade, crm, cpf, data, hora)
        VALUES (@codigo, @especialidade, @crm, @cpf, @data_converted, @hora_converted);

        SET @saida = 'Consulta cadastrada';
      END
      ELSE
      BEGIN
        IF (UPPER(@opcao) = 'U')
        BEGIN
          UPDATE Consulta
          SET codigo = @codigo,
              especialidade = @especialidade,
              crm = @crm,
              cpf = @cpf,
              data = CONVERT(DATE, @data, 103),
              hora = CONVERT(TIME, @hora)
          WHERE codigo = @codigo;

          SET @saida = 'Consulta com o código: ' + CAST(@codigo AS VARCHAR(15)) + ' atualizada';
        END
        ELSE
        BEGIN
          RAISERROR('Operação Inválida', 16, 1);
        END
      END
    END
  END
END

-- TESTANDO A PROCEDURE ACIMA
GO
DECLARE @saida1 VARCHAR(MAX)
EXEC sp_manter_consulta 'I', 1, 4, '987654', '04488308848', '14/06/2023', '15:30', @saida1 OUTPUT
PRINT @saida1 
GO
DECLARE @saida2 VARCHAR(MAX)
EXEC sp_manter_consulta 'I', 2, 1, '456789', '39340987896', '14/06/2023', '15:40', @saida2 OUTPUT
PRINT @saida2

SELECT c.codigo, e.nome as especialidade, m.nome as medico, p.nome as paciente, CONVERT(VARCHAR(10), data, 103) AS data, CONVERT(VARCHAR(5), hora, 108) AS hora 
FROM Consulta c, especialidade e, medico m, paciente p
WHERE e.codigo = c.especialidade
AND c.cpf = p.cpf
AND c.crm = m.crm

-- function ATENDENTE LISTANDO CONSULTAS  
GO
CREATE FUNCTION fn_listarconsultas()
RETURNS @table TABLE (
  data VARCHAR(10),
  hora VARCHAR(5),
  paciente VARCHAR(100),
  medico VARCHAR(100),
  especialidade VARCHAR(20)
)
AS
BEGIN
  INSERT INTO @table (data, hora, paciente, medico, especialidade)
  SELECT CONVERT(VARCHAR(10), c.data, 103) AS data, CONVERT(VARCHAR(5), c.hora, 108) AS hora, UPPER(p.nome) AS paciente, UPPER(m.nome) AS medico, UPPER(e.nome) AS especialidade
  FROM Consulta c
  INNER JOIN Paciente p ON p.cpf = c.cpf
  INNER JOIN Medico m ON m.crm = c.crm
  INNER JOIN Especialidade e ON e.codigo = c.especialidade
  ORDER BY c.data, c.hora ASC
  RETURN
END

SELECT * FROM fn_listarconsultas()

-- function ATENDENTE PESQUISANDO CONSULTAS POR CPF
GO
CREATE FUNCTION fn_pesquisarconsultas(@cpf CHAR(11))
RETURNS @table TABLE (
  data VARCHAR(10),
  hora VARCHAR(5),
  paciente VARCHAR(100),
  medico VARCHAR(100),
  especialidade VARCHAR(20)
)
AS
BEGIN
  INSERT INTO @table (data, hora, paciente, medico, especialidade)
  SELECT CONVERT(VARCHAR(10), c.data, 103) AS data, REPLACE(CONVERT(VARCHAR(5), c.hora, 108), ':00', '') AS hora, UPPER(p.nome) AS paciente, UPPER(m.nome) AS medico, UPPER(e.nome) AS especialidade
  FROM Consulta c
  INNER JOIN Paciente p ON p.cpf = c.cpf
  INNER JOIN Medico m ON m.crm = c.crm
  INNER JOIN Especialidade e ON e.codigo = c.especialidade
  WHERE p.cpf = @cpf
  ORDER BY c.data, c.hora ASC
  RETURN
END

SELECT * FROM fn_pesquisarconsultas('04488308848')


--procedure ATENDENTE MANTENDO PRONTUARIO (CREATE, UPDATE, DELETE)
GO
CREATE PROCEDURE sp_manter_prontuario (@opcao CHAR(1), @codigo INT, @cpf CHAR(11),  @crm CHAR(6), @diagnostico VARCHAR(255), @saida VARCHAR(300) OUTPUT)
AS
BEGIN
  IF (UPPER(@opcao) = 'D' AND @codigo IS NOT NULL)
  BEGIN
    DELETE FROM Prontuario
    WHERE codigo = @codigo
    SET @saida = 'Prontuário com o código: ' + CAST(@codigo AS VARCHAR(11)) + ' excluído'
  END
  ELSE
  BEGIN
    IF (UPPER(@opcao) = 'D' AND @codigo IS NULL)
    BEGIN
      RAISERROR('Prontuário não encontrado', 16, 1)
    END
    ELSE
    BEGIN
      IF (UPPER(@opcao) = 'I')
      BEGIN
        INSERT INTO Prontuario (codigo, cpf, crm, diagnostico)
        VALUES (@codigo, @cpf, @crm, @diagnostico)
        SET @saida = 'Prontuário cadastrado'
      END
      ELSE
      BEGIN
        IF (UPPER(@opcao) = 'U')
        BEGIN
          UPDATE Prontuario
          SET codigo = @codigo,
              cpf = @cpf,
              crm = @crm,
			  diagnostico = @diagnostico
          WHERE codigo = @codigo
          SET @saida = 'Prontuário com o código: ' + CAST(@codigo AS VARCHAR(15)) + ' atualizado'
        END
        ELSE
        BEGIN
          RAISERROR('Operação Inválida', 16, 1)
        END
      END
    END
  END
END
-- TESTANDO A PROCEDURE ACIMA
GO
DECLARE @saida1 VARCHAR(MAX)
EXEC sp_manter_prontuario 'I', 1, '04488308848', '987654', 'Torção no pé', @saida1 output
PRINT @saida1
GO
DECLARE @saida2 VARCHAR(MAX)
EXEC sp_manter_prontuario 'I', 2, '39340987896', '456789', 'Problema no coração', @saida2 output
PRINT @saida2

SELECT * FROM Prontuario

-- function ATENDENTE LISTANDO PRONTUARIO
GO 
CREATE FUNCTION fn_listaprontuario()
RETURNS @table TABLE (
  codigo INT,
  cpf CHAR(11),
  crm CHAR(6),
  diagnostico VARCHAR(255)
)
AS
BEGIN
  INSERT INTO @table (codigo, cpf, crm, diagnostico)
  SELECT pr.codigo, p.cpf, m.crm, pr.diagnostico
  FROM Prontuario pr
  INNER JOIN Paciente p ON p.cpf = pr.cpf
  INNER JOIN Medico m ON m.crm = pr.crm
  RETURN
END

SELECT * FROM fn_listaprontuario()


--function ATENDENTE PESQUISANDO PRONTUÁRIO
CREATE FUNCTION fn_pesquisaprontuario(@cpf CHAR(11))
RETURNS @table TABLE (
  codigo INT,
  cpf CHAR(11),
  crm CHAR(6),
  diagnostico VARCHAR(255)
)
AS
BEGIN
  INSERT INTO @table (codigo, cpf, crm, diagnostico)
  SELECT pr.codigo, p.cpf, m.crm, pr.diagnostico
  FROM Prontuario pr
  INNER JOIN Paciente p ON p.cpf = pr.cpf
  INNER JOIN Medico m ON m.crm = pr.crm
  WHERE p.cpf = @cpf
  RETURN
END

SELECT * FROM fn_pesquisaprontuario('04488308848')


--------------------------------------------------- FIM PROCEDURES E FUNÇÕES (ATENDENTE) ---------------------------------------------


--------------------------------------------------- INÍCIO PROCEDURES E FUNÇÕES (MÉDICO) ---------------------------------------------
--function MÉDICO LISTANDO CONSULTAS
GO
CREATE FUNCTION fn_listarconsultasmedico(@crm CHAR(6))
RETURNS @table TABLE (
  data VARCHAR(10),
  hora VARCHAR(5),
  paciente VARCHAR(100)
)
AS
BEGIN
  INSERT INTO @table (data, hora, paciente)
  SELECT CONVERT(VARCHAR(10), c.data, 103) AS data, CONVERT(VARCHAR(5), c.hora, 108) AS hora, p.nome
  FROM Consulta c
  INNER JOIN Paciente p ON p.cpf = c.cpf
  INNER JOIN Medico m ON m.crm = c.crm
  WHERE m.crm = @crm
  ORDER BY c.data, c.hora ASC
  RETURN
END

SELECT * FROM fn_listarconsultasmedico('987654')

--function MÉDICO PESQUISANDO CONSULTAS POR CPF
GO
CREATE FUNCTION fn_pesquisarconsultasmedico(@cpf CHAR(11))
RETURNS @table TABLE (
  data VARCHAR(10),
  hora VARCHAR(5),
  paciente VARCHAR(100)
)
AS
BEGIN
  INSERT INTO @table (data, hora, paciente)
  SELECT CONVERT(VARCHAR(10), c.data, 103) AS data, CONVERT(VARCHAR(5), c.hora, 108) AS hora, p.nome
  FROM Consulta c
  INNER JOIN Paciente p ON p.cpf = c.cpf
  INNER JOIN Medico m ON m.crm = c.crm
  WHERE p.cpf = @cpf
  ORDER BY c.data, c.hora ASC
  RETURN
END

SELECT * FROM fn_pesquisarconsultasmedico('04488308848')

-- procedure MÉDICO EDITANDO PRONTUARIO
GO
CREATE PROCEDURE sp_editar_prontuario(@opcao CHAR(1), @codigo INT, @diagnostico VARCHAR(255), @crm CHAR(6), @cpf CHAR(11), @saida VARCHAR(300) OUTPUT)
AS
BEGIN
  IF (UPPER(@opcao) = 'U')
  BEGIN
    DECLARE @medicoExiste BIT

    -- Verificar se o médico com o CRM fornecido existe
    SELECT @medicoExiste = CASE WHEN EXISTS (SELECT 1 FROM Medico WHERE crm = @crm) THEN 1 ELSE 0 END

    IF (@medicoExiste = 1)
    BEGIN
      -- Atualizar o prontuário apenas se o médico existir
      UPDATE Prontuario
      SET diagnostico = @diagnostico
      WHERE codigo = @codigo
        AND crm = @crm

      -- Verificar se a atualização foi bem-sucedida
      IF @@ROWCOUNT > 0
        SET @saida = 'Prontuário com o código: ' + CAST(@codigo AS VARCHAR(15)) + ' atualizado'
      ELSE
        SET @saida = 'Nenhum prontuário encontrado para o código: ' + CAST(@codigo AS VARCHAR(15))
    END
    ELSE
    BEGIN
      SET @saida = 'Médico com CRM ' + @crm + ' não encontrado'
    END
  END
  ELSE
  BEGIN
    RAISERROR('Operação inválida', 16, 1)
  END
END

DECLARE @saida1 VARCHAR(Max)
EXEC sp_editar_prontuario 'U', 1, 'Afastamento', '987654', '04488308848', @saida1 OUTPUT
PRINT @saida1

SELECT * FROM Prontuario WHERE codigo = 1


--------------------------------------------------- FIM PROCEDURES E FUNÇÕES (MÉDICO) ---------------------------------------------

--------------------------------------------------- INÍCIO PROCEDURES E FUNÇÕES (PACIENTE) ----------------------------------------
--function PACIENTE LISTANDO CONSULTAS
GO 
CREATE FUNCTION fn_pacientelistaconsultas(@cpf CHAR(11))
RETURNS @table TABLE (
  data VARCHAR(10),
  hora VARCHAR(5),
  medico VARCHAR(100),
  especialidade VARCHAR(20)
)
AS
BEGIN
  INSERT INTO @table (data, hora, medico, especialidade)
  SELECT CONVERT(VARCHAR(10), c.data, 103) AS data, CONVERT(VARCHAR(5), c.hora, 108) AS hora,m.nome, e.nome
  FROM Consulta c
  INNER JOIN Paciente p ON p.cpf = c.cpf
  INNER JOIN Medico m ON m.crm = c.crm
  INNER JOIN Especialidade e ON e.codigo = c.especialidade
  WHERE p.cpf = @cpf
  ORDER BY c.data, c.hora ASC
  RETURN
END

SELECT * FROM fn_pacientelistaconsultas('04488308848')


--function PACIENTE PESQUISANDO CONSULTAS
GO
CREATE FUNCTION fn_pacientepesquisaconsultas (@cpf CHAR(11), @data DATE)
RETURNS @table TABLE (
  data VARCHAR(10),
  hora VARCHAR(5),
  medico VARCHAR(100),
  especialidade VARCHAR(20)
)
AS
BEGIN
  INSERT INTO @table (data, hora, medico, especialidade)
  SELECT CONVERT(VARCHAR(10), c.data, 103) AS data, CONVERT(VARCHAR(5), c.hora, 108) AS hora, m.nome, e.nome
  FROM Consulta c
  INNER JOIN Paciente p ON p.cpf = c.cpf
  INNER JOIN Medico m ON m.crm = c.crm
  INNER JOIN Especialidade e ON e.codigo = c.especialidade
  WHERE p.cpf = @cpf
  AND c.data = @data
  ORDER BY c.data, c.hora ASC
  RETURN
END

SELECT * FROM fn_pacientepesquisaconsultas('04488308848', '2023-06-14')

