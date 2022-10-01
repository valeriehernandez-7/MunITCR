USE [MunITCR]
GO

INSERT INTO dbo.Persona 
VALUES (
  1,
  'Valerie Hernández Fernández',
  '2020010829',
  '71047856',
  '65874017',
  'valeriehernandez@estudiantec.cr',
  DEFAULT
);

INSERT INTO dbo.Usuario
VALUES (
	1,
	'valeriehernandez',
	'2022',
	0,
	DEFAULT
);

INSERT INTO dbo.Persona 
VALUES (
	1,
	'Erick Madrigal Zavala',
	'2018146983',
	'71086099',
	'99068017',
	'mazae2000@estudiantec.cr',
	DEFAULT
);

INSERT INTO dbo.Usuario
VALUES (
	2,
	'erickmadrigal',
	'2022',
	1,
	DEFAULT
);