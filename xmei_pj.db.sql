BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "aux_categoria" (
	"id_categoria"	INTEGER,
	"nome_categoria"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id_categoria" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_centrocusto" (
	"id_centro"	INTEGER,
	"nome_centro"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id_centro" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_condicao" (
	"id_condicao"	INTEGER,
	"nome_condicao"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id_condicao" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_docfiscal" (
	"id_doc"	INTEGER,
	"nome_doc"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id_doc" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_estado" (
	"id_unifed"	INTEGER,
	"estado"	TEXT NOT NULL UNIQUE,
	"sigla"	TEXT NOT NULL UNIQUE,
	"regiao"	TEXT NOT NULL,
	PRIMARY KEY("id_unifed" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_historico" (
	"id_historico"	INTEGER,
	"nome_historico"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id_historico" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_metodo" (
	"id_metodo"	INTEGER,
	"nome_metodo"	TEXT NOT NULL,
	PRIMARY KEY("id_metodo")
);
CREATE TABLE IF NOT EXISTS "aux_natureza" (
	"id_natureza"	INTEGER,
	"nome_natureza"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id_natureza" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_status" (
	"id_status"	INTEGER,
	"nome_status"	TEXT NOT NULL,
	"desc_status"	TEXT,
	PRIMARY KEY("id_status" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_status_recpag" (
	"id_status"	INTEGER,
	"nome_status"	TEXT NOT NULL UNIQUE,
	"descricao_status"	TEXT,
	PRIMARY KEY("id_status" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_tipoclifor" (
	"Id_clifor"	INTEGER,
	"tipo_clifor"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("Id_clifor" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_tipopessoa" (
	"id_pessoa"	INTEGER,
	"tipo_pessoa"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id_pessoa" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "aux_unifed" (
	"id_unifed"	INTEGER,
	"estado"	TEXT NOT NULL,
	"sigla"	TEXT NOT NULL,
	"regiao"	TEXT,
	PRIMARY KEY("id_unifed" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "cad_bancos" (
	"id_conta"	INTEGER,
	"nome_conta"	TEXT NOT NULL,
	"tipo_conta"	TEXT,
	"saldo_inicial"	DECIMAL(10, 2) DEFAULT 0,
	"num_banco"	TEXT,
	"agencia"	TEXT,
	"codigo"	TEXT,
	PRIMARY KEY("id_conta" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "cad_colaboradores" (
	"id_colaborador"	INTEGER,
	"id_pessoa"	INTEGER,
	"id_clifor"	INTEGER,
	"id_unifed"	INTEGER,
	"cpf_cnpj"	TEXT NOT NULL UNIQUE,
	"nome_colaborador"	TEXT NOT NULL,
	"contato_responsavel"	TEXT,
	"logradouro"	TEXT,
	"numero"	TEXT,
	"bairro"	TEXT,
	"municipio"	TEXT,
	"cep"	TEXT,
	"telefone"	TEXT,
	"email"	TEXT,
	PRIMARY KEY("id_colaborador" AUTOINCREMENT),
	FOREIGN KEY("id_clifor") REFERENCES "aux_tipoclifor"("Id_clifor"),
	FOREIGN KEY("id_pessoa") REFERENCES "aux_tipopessoa"("id_pessoa"),
	FOREIGN KEY("id_unifed") REFERENCES "uffederação"("id_unifed")
);
CREATE TABLE IF NOT EXISTS "cad_empresas" (
	"id_empresa"	INTEGER,
	"razao_social"	TEXT NOT NULL,
	"cnpj"	TEXT NOT NULL UNIQUE,
	"cep"	TEXT,
	"logradouro"	TEXT,
	"numero"	TEXT,
	"bairro"	TEXT,
	"municipio"	TEXT,
	"uf"	TEXT,
	"telefone"	TEXT,
	"email"	TEXT,
	"data_abertura"	DATE,
	"capital_social"	REAL,
	"cnae_empresa"	TEXT,
	"ocupacao_principal"	TEXT,
	"id_unifed"	INTEGER,
	"id_usuario"	INTEGER NOT NULL,
	"criado_em"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	"atualizado_em"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id_empresa" AUTOINCREMENT),
	FOREIGN KEY("id_usuario") REFERENCES "usuario_app"("id_usuario")
);
CREATE TABLE IF NOT EXISTS "cad_produtos" (
	"id_produto"	INTEGER,
	"codigo_interno"	TEXT UNIQUE,
	"nome_produto"	TEXT NOT NULL,
	"tipo_item"	TEXT CHECK("tipo_item" IN ('P', 'S')),
	"unidade_medida"	TEXT,
	"id_planoconta"	INTEGER,
	"preco_venda"	DECIMAL(10, 2),
	"preco_custo"	DECIMAL(10, 2),
	"estoque_minimo"	DECIMAL(10, 2) DEFAULT 0,
	"estoque_atual"	DECIMAL(10, 2) DEFAULT 0,
	PRIMARY KEY("id_produto" AUTOINCREMENT),
	FOREIGN KEY("id_planoconta") REFERENCES "config_plano"("id_planoconta")
);
CREATE TABLE IF NOT EXISTS "config_atividades" (
	"id_atividade"	INTEGER,
	"nome_atividade"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id_atividade" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "config_plano" (
	"id_planoconta"	INTEGER,
	"nome_planoconta"	TEXT NOT NULL,
	"id_atividade"	INTEGER,
	"id_categoria"	INTEGER,
	"id_centro"	INTEGER,
	"id_natureza"	INTEGER,
	PRIMARY KEY("id_planoconta" AUTOINCREMENT),
	FOREIGN KEY("id_atividade") REFERENCES "config_atividades"("id_atividade"),
	FOREIGN KEY("id_categoria") REFERENCES "aux_categoria"("id_categoria"),
	FOREIGN KEY("id_centro") REFERENCES "aux_centrocusto"("id_centro"),
	FOREIGN KEY("id_natureza") REFERENCES "aux_natureza"("id_natureza")
);
CREATE TABLE IF NOT EXISTS "config_regra" (
	"id_regra"	INTEGER,
	"id_atividade"	INTEGER,
	"limite_faturamento_anual"	DECIMAL(10, 2) NOT NULL,
	"data_inicial"	DATE NOT NULL,
	"data_final"	DATE,
	"percent_isencao"	DECIMAL(5, 2),
	"percent_inss"	DECIMAL(5, 2) DEFAULT 5.0,
	"valor_icms"	DECIMAL(10, 2),
	"valor_iss"	DECIMAL(10, 2),
	PRIMARY KEY("id_regra" AUTOINCREMENT),
	FOREIGN KEY("id_atividade") REFERENCES "config_atividades"("id_atividade")
);
CREATE TABLE IF NOT EXISTS "config_salarios" (
	"id_referencial"	INTEGER,
	"data_inicial"	DATE NOT NULL,
	"data_final"	DATE,
	"valor_salario_minimo"	DECIMAL(10, 2) NOT NULL,
	"limite_irenda"	DECIMAL(10, 2),
	PRIMARY KEY("id_referencial" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "mov_caixa" (
	"id_mov_caixa"	INTEGER,
	"id_conta"	INTEGER,
	"id_historico"	INTEGER,
	"id_mov_fin"	INTEGER,
	"data_movimento"	DATE DEFAULT (DATE('now')),
	"valor_movimento"	DECIMAL(10, 2) NOT NULL,
	"documento_ref"	TEXT,
	"saldo_atual"	DECIMAL(10, 2),
	PRIMARY KEY("id_mov_caixa" AUTOINCREMENT),
	FOREIGN KEY("id_conta") REFERENCES "cad_bancos"("id_conta"),
	FOREIGN KEY("id_historico") REFERENCES "aux_historico"("id_historico"),
	FOREIGN KEY("id_mov_fin") REFERENCES "mov_financeiro"("id_mov_fin")
);
CREATE TABLE IF NOT EXISTS "mov_financeiro" (
	"id_mov_fin"	INTEGER,
	"id_mov_op"	INTEGER,
	"num_parcela"	INTEGER DEFAULT 1,
	"data_vencimento"	DATE NOT NULL,
	"data_pagamento"	DATE,
	"id_colaborador"	INTEGER,
	"id_planoconta"	INTEGER,
	"id_metodo"	INTEGER,
	"id_condicao"	INTEGER,
	"id_historico"	INTEGER,
	"valor_previsto"	REAL NOT NULL,
	"valor_pago"	REAL DEFAULT 0,
	"juros_desconto"	REAL DEFAULT 0,
	PRIMARY KEY("id_mov_fin" AUTOINCREMENT),
	FOREIGN KEY("id_mov_op") REFERENCES "mov_operacional"("id_mov_op")
);
CREATE TABLE IF NOT EXISTS "mov_operacional" (
	"id_mov_op"	INTEGER,
	"data_emissao"	DATE DEFAULT (DATE('now')),
	"id_veiculo"	INTEGER,
	"id_doc"	INTEGER,
	"numero_doc"	TEXT,
	"id_planoconta"	INTEGER,
	"valor_bruto"	DECIMAL(10, 2),
	"valor_imposto"	DECIMAL(10, 2) DEFAULT 0,
	"base_calculo"	DECIMAL(10, 2),
	"id_colaborador"	INTEGER,
	"id_produto"	INTEGER,
	"id_condicao"	INTEGER,
	"qtd_parcelas"	INTEGER DEFAULT 1,
	"frete_info"	TEXT,
	"tributavel"	DECIMAL(10, 2),
	"status_op"	TEXT DEFAULT 'Concluido',
	PRIMARY KEY("id_mov_op" AUTOINCREMENT),
	FOREIGN KEY("id_doc") REFERENCES "aux_docfiscal"("id_doc"),
	FOREIGN KEY("id_planoconta") REFERENCES "config_plano"("id_planoconta"),
	FOREIGN KEY("id_veiculo") REFERENCES "veiculos_imob"("id_veiculo")
);
CREATE TABLE IF NOT EXISTS "usuario_app" (
	"id_usuario"	INTEGER,
	"nome_usuario"	TEXT NOT NULL UNIQUE,
	"email"	TEXT NOT NULL UNIQUE,
	"senha_hash"	TEXT NOT NULL,
	"nome_completo"	TEXT,
	"telefone"	TEXT,
	"perfil"	TEXT DEFAULT 'usuario',
	"status"	TEXT DEFAULT 'ativo',
	"ultimo_login"	DATETIME,
	"criado_em"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	"atualizado_em"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id_usuario" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "usuario_empresa" (
	"id_usuario"	INTEGER NOT NULL,
	"id_empresa"	INTEGER NOT NULL,
	"perfil"	TEXT DEFAULT 'usuario',
	PRIMARY KEY("id_usuario","id_empresa"),
	FOREIGN KEY("id_empresa") REFERENCES "cad_empresas"("id_empresa"),
	FOREIGN KEY("id_usuario") REFERENCES "usuario_app"("id_usuario")
);
CREATE TABLE IF NOT EXISTS "veiculos_imob" (
	"id_veiculo"	INTEGER,
	"id_unifed"	INTEGER,
	"placa"	TEXT NOT NULL UNIQUE,
	"modelo_marca"	TEXT,
	"ano_fabricacao"	INTEGER,
	"cor"	TEXT,
	"tipo_veiculo"	TEXT,
	"tipo_combustivel"	TEXT,
	"km_inicial"	DECIMAL(10, 2),
	"renavam"	TEXT,
	"tara_kg"	DECIMAL(10, 2),
	"capacidade_kg"	DECIMAL(10, 2),
	"observacoes"	TEXT,
	PRIMARY KEY("id_veiculo" AUTOINCREMENT),
	FOREIGN KEY("id_unifed") REFERENCES "uffederação"("id_unifed")
);
INSERT INTO "aux_categoria" VALUES (1,'Receitas');
INSERT INTO "aux_categoria" VALUES (2,'Despesas');
INSERT INTO "aux_categoria" VALUES (3,'Ativo');
INSERT INTO "aux_categoria" VALUES (4,'Passivo');
INSERT INTO "aux_centrocusto" VALUES (1,'Operacional');
INSERT INTO "aux_centrocusto" VALUES (2,'Administração');
INSERT INTO "aux_centrocusto" VALUES (3,'Financeiro');
INSERT INTO "aux_centrocusto" VALUES (4,'Diretoria');
INSERT INTO "aux_centrocusto" VALUES (5,'Estoques');
INSERT INTO "aux_centrocusto" VALUES (6,'Investimentos');
INSERT INTO "aux_centrocusto" VALUES (7,'Impostos');
INSERT INTO "aux_centrocusto" VALUES (8,'Frotas');
INSERT INTO "aux_centrocusto" VALUES (9,'Geral');
INSERT INTO "aux_condicao" VALUES (1,'A vista');
INSERT INTO "aux_condicao" VALUES (2,'Parcelado');
INSERT INTO "aux_condicao" VALUES (3,'Permuta');
INSERT INTO "aux_docfiscal" VALUES (1,'NFSE');
INSERT INTO "aux_docfiscal" VALUES (2,'NFE');
INSERT INTO "aux_docfiscal" VALUES (3,'Sem NF');
INSERT INTO "aux_docfiscal" VALUES (4,'Recibo');
INSERT INTO "aux_docfiscal" VALUES (5,'Fatura');
INSERT INTO "aux_estado" VALUES (1,'Acre','AC','Norte');
INSERT INTO "aux_estado" VALUES (2,'Alagoas','AL','Nordeste');
INSERT INTO "aux_estado" VALUES (3,'Amapá','AP','Norte');
INSERT INTO "aux_estado" VALUES (4,'Amazonas','AM','Norte');
INSERT INTO "aux_estado" VALUES (5,'Bahia','BA','Nordeste');
INSERT INTO "aux_estado" VALUES (6,'Ceará','CE','Nordeste');
INSERT INTO "aux_estado" VALUES (7,'Distrito Federal','DF','Centro-Oeste');
INSERT INTO "aux_estado" VALUES (8,'Espírito Santo','ES','Sudeste');
INSERT INTO "aux_estado" VALUES (9,'Goiás','GO','Centro-Oeste');
INSERT INTO "aux_estado" VALUES (10,'Maranhão','MA','Nordeste');
INSERT INTO "aux_estado" VALUES (11,'Mato Grosso','MT','Centro-Oeste');
INSERT INTO "aux_estado" VALUES (12,'Mato Grosso do Sul','MS','Centro-Oeste');
INSERT INTO "aux_estado" VALUES (13,'Minas Gerais','MG','Sudeste');
INSERT INTO "aux_estado" VALUES (14,'Pará','PA','Norte');
INSERT INTO "aux_estado" VALUES (15,'Paraíba','PB','Nordeste');
INSERT INTO "aux_estado" VALUES (16,'Paraná','PR','Sul');
INSERT INTO "aux_estado" VALUES (17,'Pernambuco','PE','Nordeste');
INSERT INTO "aux_estado" VALUES (18,'Piauí','PI','Nordeste');
INSERT INTO "aux_estado" VALUES (19,'Rio de Janeiro','RJ','Sudeste');
INSERT INTO "aux_estado" VALUES (20,'Rio Grande do Norte','RN','Nordeste');
INSERT INTO "aux_estado" VALUES (21,'Rio Grande do Sul','RS','Sul');
INSERT INTO "aux_estado" VALUES (22,'Rondônia','RO','Norte');
INSERT INTO "aux_estado" VALUES (23,'Roraima','RR','Norte');
INSERT INTO "aux_estado" VALUES (24,'Santa Catarina','SC','Sul');
INSERT INTO "aux_estado" VALUES (25,'São Paulo','SP','Sudeste');
INSERT INTO "aux_estado" VALUES (26,'Sergipe','SE','Nordeste');
INSERT INTO "aux_estado" VALUES (27,'Tocantins','TO','Norte');
INSERT INTO "aux_historico" VALUES (1,'Entrada_Recebimento_Débito_Haver');
INSERT INTO "aux_historico" VALUES (2,'Saída_Pagamento_Crédito_Deve');
INSERT INTO "aux_metodo" VALUES (1,'Dinheiro');
INSERT INTO "aux_metodo" VALUES (2,'Pix');
INSERT INTO "aux_metodo" VALUES (3,'Transferências');
INSERT INTO "aux_metodo" VALUES (4,'Cheque');
INSERT INTO "aux_metodo" VALUES (5,'Boleto');
INSERT INTO "aux_metodo" VALUES (6,'Fatura');
INSERT INTO "aux_metodo" VALUES (7,'Débito em Conta');
INSERT INTO "aux_metodo" VALUES (8,'Crédito em Conta');
INSERT INTO "aux_metodo" VALUES (9,'Cartão de Crédito');
INSERT INTO "aux_metodo" VALUES (10,'Cartão de Débito');
INSERT INTO "aux_metodo" VALUES (11,'Ted');
INSERT INTO "aux_natureza" VALUES (1,'Custo Fixo');
INSERT INTO "aux_natureza" VALUES (2,'Custo Variável');
INSERT INTO "aux_natureza" VALUES (3,'Geral');
INSERT INTO "aux_status_recpag" VALUES (1,'Aberto','Documento ainda não iniciado');
INSERT INTO "aux_status_recpag" VALUES (2,'À vencer','Documento/obrigação próximo do vencimento');
INSERT INTO "aux_status_recpag" VALUES (3,'Liquidado','Documento/obrigação pago/concluído');
INSERT INTO "aux_tipoclifor" VALUES (1,'Cliente');
INSERT INTO "aux_tipoclifor" VALUES (2,'Fornecedor');
INSERT INTO "aux_tipoclifor" VALUES (3,'Funcionário');
INSERT INTO "aux_tipoclifor" VALUES (4,'Motorista');
INSERT INTO "aux_tipopessoa" VALUES (1,'Pessoa Física');
INSERT INTO "aux_tipopessoa" VALUES (2,'Pessoa Jurídica');
INSERT INTO "aux_tipopessoa" VALUES (3,'Governos');
INSERT INTO "cad_colaboradores" VALUES (1,NULL,NULL,NULL,'239.720.929-20','Israel Augusto',NULL,'Rua Guarujá','191','Jardim Maria Helena','Barueri','06445070','11992574664','israelbizzarri@gmail.com');
INSERT INTO "cad_colaboradores" VALUES (2,2,1,25,'17.968.335/0001-09','Bruno Augusto de Matos da Silva','Maria','Rua Guarujá','191','Jardim Maria Helena','Barueri','06445-070','11992574664','gbizz.idi@gmail.com');
INSERT INTO "cad_colaboradores" VALUES (3,NULL,NULL,NULL,'50.118.354/0001-03','Gbizz Incubadora de ideias','Maria','Rua Guarujá','191','Jardim Maria Helena','Barueri','06445070','11992574664','gbizz.idi@gmail.com');
INSERT INTO "cad_empresas" VALUES (1,'Empresa Alpha LTDA','12.345.678/0001-99','06320-000','Rua das Flores','123','Centro','Carapicuíba','SP','+55 11 4000-1234','alpha@empresa.com','2018-01-10',100000.0,'6201500','Comércio varejista',1,1,'2026-03-13 12:17:10','2026-03-13 12:17:10');
INSERT INTO "cad_empresas" VALUES (2,'Empresa Beta ME','98.765.432/0001-55','06320-001','Av. Brasil','456','Jardim','Osasco','SP','+55 11 4000-5678','beta@empresa.com','2021-07-15',50000.0,'4711300','Serviços de TI',2,1,'2026-03-13 12:17:10','2026-03-13 12:17:10');
INSERT INTO "cad_produtos" VALUES (1,'SV-001','Assessoria','S','un',3,10000,0,0,0);
INSERT INTO "config_atividades" VALUES (1,'COMÉRCIO');
INSERT INTO "config_atividades" VALUES (2,'INDÚSTRIA');
INSERT INTO "config_atividades" VALUES (3,'SERVIÇOS');
INSERT INTO "config_atividades" VALUES (4,'TRANSPORTE DE PASSAGEIROS');
INSERT INTO "config_atividades" VALUES (5,'TRANSPORTE DE CARGAS');
INSERT INTO "config_plano" VALUES (1,'Revenda de Mercadorias',1,1,9,3);
INSERT INTO "config_plano" VALUES (2,'Venda de Produção da Indústria',2,1,9,3);
INSERT INTO "config_plano" VALUES (3,'Serviço',3,1,9,3);
INSERT INTO "config_plano" VALUES (4,'Lotação e Carretos',4,1,9,3);
INSERT INTO "config_plano" VALUES (5,'Fretes e Cargas',5,1,9,3);
INSERT INTO "config_regra" VALUES (1,1,81000,'2023-01-01','2020-12-31',8,5,1,0);
INSERT INTO "config_regra" VALUES (2,2,81000,'2023-01-01','2020-12-31',8,5,1,0);
INSERT INTO "config_regra" VALUES (3,3,81000,'2023-01-01','2020-12-31',32,5,0,5);
INSERT INTO "config_regra" VALUES (4,5,251600,'2023-01-01','2020-12-31',8,12,1,5);
INSERT INTO "config_regra" VALUES (5,4,81000,'2023-01-01','2020-12-31',16,5,1,5);
INSERT INTO "config_regra" VALUES (6,1,81000,'2024-01-01',NULL,8,5,1,0);
INSERT INTO "config_regra" VALUES (7,2,81000,'2024-01-01',NULL,8,5,1,0);
INSERT INTO "config_regra" VALUES (8,3,81000,'2024-01-01',NULL,32,5,0,5);
INSERT INTO "config_regra" VALUES (9,5,251600,'2024-01-01',NULL,8,12,1,5);
INSERT INTO "config_regra" VALUES (10,4,81000,'2024-01-01',NULL,16,5,1,5);
INSERT INTO "config_regra" VALUES (11,1,81000,'2025-01-01',NULL,8,5,1,0);
INSERT INTO "config_regra" VALUES (12,2,81000,'2025-01-01',NULL,8,5,1,0);
INSERT INTO "config_regra" VALUES (13,3,81000,'2025-01-01',NULL,32,5,1,5);
INSERT INTO "config_regra" VALUES (14,5,251600,'2025-01-01',NULL,8,12,1,5);
INSERT INTO "config_regra" VALUES (15,4,81000,'2025-01-01',NULL,16,5,1,5);
INSERT INTO "config_regra" VALUES (16,1,81000,'2026-01-01',NULL,8,5,1,0);
INSERT INTO "config_regra" VALUES (17,2,81000,'2026-01-01',NULL,8,5,1,0);
INSERT INTO "config_regra" VALUES (18,3,81000,'2026-01-01',NULL,32,5,0,5);
INSERT INTO "config_regra" VALUES (19,5,251600,'2026-01-01',NULL,8,12,1,5);
INSERT INTO "config_regra" VALUES (20,4,81000,'2026-01-01',NULL,16,5,1,5);
INSERT INTO "config_salarios" VALUES (1,'2020-01-01','2020-12-31',1100,28559.7);
INSERT INTO "config_salarios" VALUES (2,'2021-01-01','2021-12-31',1212,28559.7);
INSERT INTO "config_salarios" VALUES (3,'2022-01-01','2022-12-31',1302,28559.7);
INSERT INTO "config_salarios" VALUES (4,'2023-01-01','2023-12-31',1320,28559.7);
INSERT INTO "config_salarios" VALUES (5,'2024-01-01','2024-12-31',1412,30639.9);
INSERT INTO "config_salarios" VALUES (6,'2025-01-01','2025-12-31',1518,33888.8);
INSERT INTO "config_salarios" VALUES (7,'2026-01-01',NULL,1621,33888.8);
INSERT INTO "mov_operacional" VALUES (1,'2026-01-01',NULL,NULL,NULL,5,5000,0,NULL,2,NULL,NULL,1,NULL,NULL,'Concluido');
INSERT INTO "usuario_app" VALUES (1,'israel123','israel@email.com','$2a$12$ExemploDeHashGeradoComBcrypt1234567890','Israel Silva','+55 11 91234-5678','usuario','ativo',NULL,'2026-03-13 12:17:10','2026-03-13 12:17:10');
INSERT INTO "usuario_empresa" VALUES (1,1,'admin');
INSERT INTO "usuario_empresa" VALUES (1,2,'colaborador');
COMMIT;
