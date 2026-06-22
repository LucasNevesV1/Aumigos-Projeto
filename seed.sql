-- =============================================================
-- AUMIGOS — SEED COMPLETO
-- 1 Admin | 2 ONGs | 2 Apoiadores | 2 Vets
-- Módulos principais: 50+ registros cada
-- Senha padrão todos os usuários: aumigos123
-- =============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;

-- -------------------------------------------------------------
-- LIMPA TUDO
-- -------------------------------------------------------------
TRUNCATE TABLE vacinacao;
TRUNCATE TABLE vermifugacao;
TRUNCATE TABLE exame;
TRUNCATE TABLE prontuario;
TRUNCATE TABLE medicoveterinario;
TRUNCATE TABLE produtodoacao;
TRUNCATE TABLE movimentacaoestoque;
TRUNCATE TABLE estoque;
TRUNCATE TABLE produto;
TRUNCATE TABLE adocao;
TRUNCATE TABLE animal;
TRUNCATE TABLE entradaanimal;
TRUNCATE TABLE doacao;
TRUNCATE TABLE financeiro;
TRUNCATE TABLE log_auditoria;
TRUNCATE TABLE reset_senha;
TRUNCATE TABLE usuario;
TRUNCATE TABLE endereco;
TRUNCATE TABLE tipousuario;
TRUNCATE TABLE statusadocao;
TRUNCATE TABLE categoriafinanceira;
TRUNCATE TABLE formapagamento;
TRUNCATE TABLE statuspagamento;
TRUNCATE TABLE categoriaproduto;
TRUNCATE TABLE tipodoacao;
TRUNCATE TABLE vacina;
TRUNCATE TABLE remedio;

-- -------------------------------------------------------------
-- LOOKUPS
-- -------------------------------------------------------------
INSERT INTO tipousuario (id_tipoUsuario, descricaoUsuario) VALUES
(1,'Administrador'),(2,'ONG'),(3,'Apoiador'),(4,'Médico Veterinário');

INSERT INTO statusadocao (id_statusAdocao, statusNome, statusSituacao, observacoes, dataCriacao) VALUES
(1,'Pendente','1',NULL,'2025-01-01'),
(2,'Aprovado','1',NULL,'2025-01-01'),
(3,'Recusado','0',NULL,'2025-01-01');

INSERT INTO categoriafinanceira (id_categoriaFinanceira, categoriaFinanceira, descricao) VALUES
(1,'Doação','Entrada de valores doados'),
(2,'Alimentação','Compra de ração e petiscos'),
(3,'Veterinário','Consultas e procedimentos'),
(4,'Medicamentos','Compra de medicamentos e vacinas'),
(5,'Infraestrutura','Manutenção e reformas do abrigo'),
(6,'Eventos','Feiras e campanhas de adoção'),
(7,'Marketing','Divulgação e materiais'),
(8,'Outros','Despesas diversas');

INSERT INTO formapagamento (id_formaPagamento, formaPagamento) VALUES
(1,'Dinheiro'),(2,'Pix'),(3,'Cartão de Crédito'),(4,'Cartão de Débito'),(5,'Transferência');

INSERT INTO statuspagamento (id_statusPagamento, statusPagamento) VALUES
(1,'Pendente'),(2,'Pago'),(3,'Cancelado');

INSERT INTO categoriaproduto (id_categoriaProduto, categoria, descricao) VALUES
(1,'Ração','Alimentos para animais'),
(2,'Medicamento','Produtos veterinários'),
(3,'Higiene','Produtos de limpeza e cuidado'),
(4,'Acessórios','Coleiras, brinquedos, etc');

INSERT INTO tipodoacao (id_tipoDoacao, tipoDoacao) VALUES
(1,'Dinheiro'),(2,'Produto'),(3,'Serviço');

-- -------------------------------------------------------------
-- ENDEREÇOS (7)
-- -------------------------------------------------------------
INSERT INTO endereco (id_endereco, logradouro_tipo, logradouro_nome, numero, cep, complemento, bairro, cidade, estado) VALUES
(1,'Rua','XV de Novembro',        123, '80010-000',NULL,      'Centro',    'Curitiba','PR'),
(2,'Avenida','Sete de Setembro', 2450,'80230-090','Sala 305','Rebouças',   'Curitiba','PR'),
(3,'Rua','Mateus Leme',           890,'80510-000',NULL,      'São Francisco','Curitiba','PR'),
(4,'Rua','Padre Anchieta',       1750,'80730-000',NULL,      'Bigorrilho', 'Curitiba','PR'),
(5,'Rua','Carlos Dietzsch',       450,'81200-100',NULL,      'Boqueirão',  'Curitiba','PR'),
(6,'Rua','João Bettega',         1560,'81020-310','Casa',    'Portão',     'Curitiba','PR'),
(7,'Avenida','República Argentina',3200,'80320-000',NULL,    'Portão',     'Curitiba','PR');

-- -------------------------------------------------------------
-- USUÁRIOS (7) — senha: aumigos123
-- -------------------------------------------------------------
INSERT INTO usuario (id_usuario, nome, documento, email, telefone, senha, id_tipoUsuario, dataCadastro, dataNascimento, profissao, genero, id_endereco, ativo) VALUES
(1,'Admin Master',                NULL,                 'admin@aumigos.com',              '(41) 99999-9999','$2y$10$9BbJyW46U78bqlsT.EpHM.w2vjQ5QZSlLOp1KOeBZF9c0VKqpaBBS',1,'2025-01-01','1990-01-01',NULL,NULL,NULL,1),
(2,'Lucas das Neves Bordignon',   '069.156.189-37',     'lucasbordignon2011@hotmail.com', '(41) 99778-5265','$2y$10$9BbJyW46U78bqlsT.EpHM.w2vjQ5QZSlLOp1KOeBZF9c0VKqpaBBS',2,'2025-01-10',NULL,NULL,NULL,1,1),
(3,'Patas do Bem',                '78.111.502/0001-87', 'patasbem@email.com',             '(41) 99778-0001','$2y$10$9BbJyW46U78bqlsT.EpHM.w2vjQ5QZSlLOp1KOeBZF9c0VKqpaBBS',2,'2025-01-15',NULL,NULL,NULL,3,1),
(4,'Dr. Carlos Eduardo Lima',     '45678912300',        'carlos.lima@vet.com',            '(41) 99001-0001','$2y$10$9BbJyW46U78bqlsT.EpHM.w2vjQ5QZSlLOp1KOeBZF9c0VKqpaBBS',4,'2025-01-20','1985-09-10','Médico Veterinário','Masculino',4,1),
(5,'Dra. Maria Santos',           '74185296300',        'maria.santos@vet.com',           '(41) 99001-0002','$2y$10$9BbJyW46U78bqlsT.EpHM.w2vjQ5QZSlLOp1KOeBZF9c0VKqpaBBS',4,'2025-01-25','1990-11-30','Médico Veterinário','Feminino',5,1),
(6,'Guilherme Trombini',          '126.277.679-17',     'guicastroyt@gmail.com',          '(41) 99838-3103','$2y$10$9BbJyW46U78bqlsT.EpHM.w2vjQ5QZSlLOp1KOeBZF9c0VKqpaBBS',3,'2025-02-01','1998-06-15','Designer','Masculino',6,1),
(7,'Mariana Souza',               '98765432100',        'mariana.souza@email.com',        '(41) 99002-0001','$2y$10$9BbJyW46U78bqlsT.EpHM.w2vjQ5QZSlLOp1KOeBZF9c0VKqpaBBS',3,'2025-02-10','1998-05-22','Designer UX','Feminino',7,1);

INSERT INTO medicoveterinario (id_veterinario, crmv, uf_crmv, especialidade, id_usuario) VALUES
(1,'23456','PR','Cirurgia Veterinária',4),
(2,'34567','PR','Dermatologia Veterinária',5);

-- -------------------------------------------------------------
-- ENTRADAS DE ANIMAIS (55)
-- -------------------------------------------------------------
INSERT INTO entradaanimal (id_entrada, motivoEntrada, statusSaude, descricaoEntrada, dataEntrada) VALUES
(1, 'Abandono',           'Saudável',   'Animal deixado na porta da ONG durante a madrugada',          '2025-01-05'),
(2, 'Resgate',            'Ferido',     'Cachorro atropelado, encaminhado por moradores da região',    '2025-01-08'),
(3, 'Entrega voluntária', 'Saudável',   'Tutor não tinha mais condições de cuidar',                   '2025-01-12'),
(4, 'Resgate',            'Doente',     'Gato com suspeita de infecção respiratória',                 '2025-01-15'),
(5, 'Abandono',           'Debilitado', 'Filhote encontrado em caixa de papelão',                     '2025-01-18'),
(6, 'Resgate',            'Ferido',     'Animal com machucado profundo na pata traseira',             '2025-01-22'),
(7, 'Entrega voluntária', 'Saudável',   'Família mudou de cidade e não levou o animal',               '2025-01-25'),
(8, 'Resgate',            'Debilitado', 'Animal encontrado em terreno baldio, muito magro',           '2025-01-28'),
(9, 'Abandono',           'Saudável',   'Sinais de problema de pele, estado geral OK',                '2025-02-03'),
(10,'Resgate',            'Saudável',   'Filhote recolhido após denúncia de vizinho',                 '2025-02-08'),
(11,'Entrega voluntária', 'Saudável',   'Tutora faleceu, família doou o animal',                     '2025-02-12'),
(12,'Abandono',           'Tratamento', 'Gato com ferida no focinho, estava sozinho há dias',         '2025-02-16'),
(13,'Resgate',            'Debilitado', 'Cachorra desnutrida, resgatada de situação de maus-tratos',  '2025-02-20'),
(14,'Entrega voluntária', 'Saudável',   'Proprietário mudou para apartamento sem pets',               '2025-02-25'),
(15,'Abandono',           'Saudável',   'Poodle encontrado amarrado em poste na rua',                '2025-03-01'),
(16,'Resgate',            'Ferido',     'Animal atropelado, fratura na pata dianteira direita',       '2025-03-05'),
(17,'Abandono',           'Saudável',   'Filhotes de gato encontrados em saco plástico',             '2025-03-08'),
(18,'Resgate',            'Doente',     'Cão com sarna generalizada e perda de pelo',                '2025-03-12'),
(19,'Entrega voluntária', 'Saudável',   'Casal teve bebê e não pôde continuar cuidando',             '2025-03-16'),
(20,'Abandono',           'Saudável',   'Beagle jovem encontrado sem coleira no parque',             '2025-03-20'),
(21,'Resgate',            'Debilitado', 'Gata prenhe resgatada de área de risco',                    '2025-03-25'),
(22,'Abandono',           'Saudável',   'Dálmata jovem abandonado em área rural',                    '2025-03-28'),
(23,'Entrega voluntária', 'Saudável',   'Responsável hospitalizou e não tinha quem cuidasse',        '2025-04-02'),
(24,'Resgate',            'Ferido',     'Cachorro com corte profundo no pescoço',                    '2025-04-06'),
(25,'Abandono',           'Saudável',   'Vira-lata filhote, saúde aparentemente boa',               '2025-04-10'),
(26,'Resgate',            'Doente',     'Gato com conjuntivite bilateral grave',                     '2025-04-15'),
(27,'Entrega voluntária', 'Saudável',   'Raça grande, dono morou em estúdio sem espaço',            '2025-04-20'),
(28,'Abandono',           'Debilitado', 'Animal idoso, pelagem muito descuidada',                    '2025-04-25'),
(29,'Resgate',            'Saudável',   'Filhotes resgatados de interior de bueiro',                 '2025-05-01'),
(30,'Entrega voluntária', 'Saudável',   'Lote de filhotes, mãe morreu durante o parto',             '2025-05-05'),
(31,'Abandono',           'Saudável',   'Gato castrado e vacinado, dono foi embora do país',        '2025-05-10'),
(32,'Resgate',            'Ferido',     'Animal vítima de maus-tratos, costelas fraturadas',         '2025-05-15'),
(33,'Abandono',           'Saudável',   'Golden filhote encontrado sozinho na calçada',              '2025-05-20'),
(34,'Entrega voluntária', 'Saudável',   'Guarda municipal trouxe cão recolhido na via',             '2025-05-25'),
(35,'Resgate',            'Doente',     'Cachorro com cinomose suspeita, em isolamento',             '2025-06-01'),
(36,'Abandono',           'Saudável',   'Gato adulto, bem socializado e vacinado',                   '2025-06-05'),
(37,'Resgate',            'Debilitado', 'Filhote de cachorro muito fraco ao ser encontrado',         '2025-06-10'),
(38,'Entrega voluntária', 'Saudável',   'Dono mudou para lar assistido, não pode levar',            '2025-06-15'),
(39,'Abandono',           'Saudável',   'Dois gatos adultos castrados entregues juntos',             '2025-06-20'),
(40,'Resgate',            'Tratamento', 'Cão resgatado de cativeiro com sinais de trauma',          '2025-07-01'),
(41,'Abandono',           'Saudável',   'Filhote de shih-tzu deixado em frente ao abrigo',         '2025-07-10'),
(42,'Resgate',            'Ferido',     'Gata com queimaduras leves nas patas',                     '2025-07-15'),
(43,'Entrega voluntária', 'Saudável',   'Aposentado faleceu, vizinho trouxe os dois gatos',         '2025-07-20'),
(44,'Abandono',           'Saudável',   'Boxer adulto encontrado com coleira mas sem tutor',         '2025-08-01'),
(45,'Resgate',            'Debilitado', 'Spitz alemão encontrado com matéria em todo pelo',          '2025-08-10'),
(46,'Entrega voluntária', 'Saudável',   'Família viajou ao exterior e deixou os animais',           '2025-08-20'),
(47,'Abandono',           'Saudável',   'Cachorra grávida encontrada em área industrial',            '2025-09-01'),
(48,'Resgate',            'Doente',     'Gato com FIV positivo, necessita cuidados especiais',      '2025-09-10'),
(49,'Entrega voluntária', 'Saudável',   'Tutora diagnosticada com alergia a pelos',                 '2025-09-20'),
(50,'Abandono',           'Saudável',   'Husky siberiano encontrado em condomínio',                 '2025-10-01'),
(51,'Resgate',            'Ferido',     'Cão atropelado em rodovia, fratura no quadril',            '2025-10-15'),
(52,'Entrega voluntária', 'Saudável',   'Casal em separação, animal sem responsável',               '2025-11-01'),
(53,'Abandono',           'Saudável',   'Labrador idoso encontrado em parque',                      '2025-11-15'),
(54,'Resgate',            'Debilitado', 'Gata com filhotes resgatada de área alagada',              '2025-12-01'),
(55,'Entrega voluntária', 'Saudável',   'Dono transferido para outra cidade sem poder levar',       '2025-12-15');

-- -------------------------------------------------------------
-- ANIMAIS (55)
-- ONG Lucas (id=2): animais 1-28
-- ONG Patas do Bem (id=3): animais 29-55
-- status ENUM: disponivel | tratamento | processo | adotado
-- -------------------------------------------------------------
INSERT INTO animal (id_animal, id_entrada, id_usuario, nome, especie, raca, genero, dataNascimento, cor, tamanho, idadeAproximada, residenteAbrigo, descricao, status) VALUES
(1, 1, 2,'Rexona',  'Cachorro','Vira-lata',       'Macho', '2022-03-10','Caramelo',       'Médio',   NULL,1,'Muito dócil, adora crianças e outros animais.',                   'disponivel'),
(2, 2, 2,'Luna',    'Gato',    'Siamês',          'Fêmea', '2023-07-05','Branco e cinza', 'Pequeno', NULL,1,'Tranquila e carinhosa, adora colo.',                              'disponivel'),
(3, 3, 2,'Thor',    'Cachorro','Pitbull',         'Macho', '2021-11-20','Preto',          'Grande',  NULL,1,'Resgatado após atropelamento, já recuperado e disponível.',        'disponivel'),
(4, 4, 2,'Mel',     'Cachorro','Poodle',          'Fêmea', '2020-09-15','Branco',         'Pequeno', NULL,1,'Muito ativa e amigável, aprende comandos com facilidade.',         'disponivel'),
(5, 5, 2,'Simba',   'Gato',    'Vira-lata',       'Macho', NULL,        'Laranja',        'Pequeno', 2,   0,'Filhote tranquilo e sociável. Adotado por família.',              'adotado'),
(6, 6, 2,'Nina',    'Cachorro','Pinscher',        'Fêmea', '2022-01-25','Preto e marrom', 'Pequeno', NULL,1,'Chegou debilitada, já recuperada. Muito carinhosa.',              'disponivel'),
(7, 7, 2,'Bob',     'Cachorro','Labrador',        'Macho', '2019-06-18','Amarelo',        'Grande',  NULL,0,'Muito brincalhão, adora água e passeios longos.',                 'adotado'),
(8, 8, 2,'Mia',     'Gato',    'Persa',           'Fêmea', '2021-04-30','Cinza',          'Pequeno', NULL,0,'Independente e elegante, prefere ambientes calmos.',              'adotado'),
(9, 9, 2,'Amora',   'Cachorro','Vira-lata',       'Fêmea', '2023-02-14','Preto',          'Médio',   NULL,1,'Em tratamento de pele, já apresenta melhora significativa.',      'tratamento'),
(10,10, 2,'Rex',    'Cachorro','Pastor Alemão',   'Macho', '2024-07-17','Marrom e preto', 'Grande',  NULL,1,'Filhote inteligente e obediente.',                                'disponivel'),
(11,11, 2,'Coco',   'Gato',    'Angorá',          'Macho', '2020-05-10','Branco',         'Médio',   NULL,1,'Adulto manso e silencioso, ótimo para apartamentos.',             'disponivel'),
(12,12, 2,'Frida',  'Gato',    'SRD',             'Fêmea', '2023-10-01','Tigrada',        'Pequeno', NULL,1,'Em recuperação de ferida no focinho.',                            'tratamento'),
(13,13, 2,'Brisa',  'Cachorro','Vira-lata',       'Fêmea', '2021-08-22','Caramelo',       'Médio',   NULL,1,'Resgatada de maus-tratos, ganhando confiança.',                   'disponivel'),
(14,14, 2,'Duke',   'Cachorro','Beagle',          'Macho', '2022-12-10','Tricolor',       'Médio',   NULL,1,'Curioso e enérgico, adora farejar.',                              'disponivel'),
(15,15, 2,'Fifi',   'Cachorro','Poodle',          'Fêmea', '2019-03-05','Bege',           'Pequeno', NULL,1,'Adulta e muito dócil, castrada e vacinada.',                      'disponivel'),
(16,16, 2,'Ares',   'Cachorro','Dálmata',         'Macho', '2023-03-15','Branco e preto', 'Grande',  NULL,1,'Em recuperação de fratura, cirurgia realizada.',                  'tratamento'),
(17,17, 2,'Bolinha','Gato',    'SRD',             'Macho', NULL,        'Laranja',        'Pequeno', 0,   1,'Filhote sociável e brincalhão.',                                  'disponivel'),
(18,18, 2,'Brutus', 'Cachorro','Rottweiler',      'Macho', '2021-06-01','Preto e marrom', 'Grande',  NULL,1,'Tratado de sarna, totalmente recuperado.',                        'disponivel'),
(19,19, 2,'Meg',    'Cachorro','Golden Retriever','Fêmea', '2020-10-15','Dourado',        'Grande',  NULL,1,'Dócil e amorosa, ótima com crianças.',                            'disponivel'),
(20,20, 2,'Pipoca', 'Cachorro','Beagle',          'Fêmea', '2024-01-10','Tricolor',       'Médio',   NULL,1,'Jovem e cheia de energia, aprende rápido.',                       'disponivel'),
(21,21, 2,'Aurora', 'Gato',    'SRD',             'Fêmea', NULL,        'Caramelo',       'Pequeno', 0,   0,'Resgatada grávida, filhotes desmamados. Adotada.',                'adotado'),
(22,22, 2,'Apolo',  'Cachorro','Dálmata',         'Macho', '2023-04-20','Branco e preto', 'Grande',  NULL,1,'Ativo e alegre, precisa de espaço para correr.',                  'disponivel'),
(23,23, 2,'Toby',   'Cachorro','Shih Tzu',        'Macho', '2018-08-30','Branco',         'Pequeno', NULL,1,'Adulto e calmo, adora colo. Castrado e vacinado.',                'disponivel'),
(24,24, 2,'Zeus',   'Cachorro','Pastor Alemão',   'Macho', '2022-02-14','Preto e marrom', 'Grande',  NULL,0,'Ferida cicatrizada. Muito leal e inteligente.',                   'adotado'),
(25,25, 2,'Pingo',  'Cachorro','Vira-lata',       'Macho', NULL,        'Preto',          'Pequeno', 0,   1,'Filhote saudável, vacinado e vermifugado.',                       'disponivel'),
(26,26, 2,'Kira',   'Gato',    'SRD',             'Fêmea', '2022-07-07','Cinza',          'Médio',   NULL,1,'Recuperada de conjuntivite, visão normal.',                       'disponivel'),
(27,27, 2,'Hulk',   'Cachorro','São Bernardo',    'Macho', '2021-11-01','Branco e marrom','Grande',  NULL,1,'Dócil apesar do tamanho, precisa de quintal.',                    'disponivel'),
(28,28, 2,'Nala',   'Gato',    'Persa',           'Fêmea', '2017-05-20','Cinza',          'Médio',   NULL,1,'Idosa e calma, adora rotina tranquila.',                          'disponivel'),
(29,29, 3,'Fofo',   'Cachorro','Vira-lata',       'Macho', NULL,        'Caramelo',       'Pequeno', 0,   1,'Filhote encontrado em bueiro, saudável.',                         'disponivel'),
(30,30, 3,'Lola',   'Cachorro','Vira-lata',       'Fêmea', NULL,        'Branco',         'Pequeno', 0,   1,'Filhote de lote resgatado, muito dócil.',                         'disponivel'),
(31,31, 3,'Gizmo',  'Gato',    'Persa',           'Macho', '2020-03-12','Branco',         'Médio',   NULL,1,'Castrado e vacinado, tranquilo e adaptável.',                     'disponivel'),
(32,32, 3,'Leão',   'Cachorro','Fila Brasileiro', 'Macho', '2021-09-05','Caramelo',       'Grande',  NULL,1,'Recuperado de maus-tratos, carinhoso com quem conhece.',          'disponivel'),
(33,33, 3,'Buddy',  'Cachorro','Golden Retriever','Macho', NULL,        'Dourado',        'Grande',  0,   0,'Filhote adotado por família logo na chegada.',                    'adotado'),
(34,34, 3,'Lara',   'Cachorro','Labrador',        'Fêmea', '2022-05-18','Preta',          'Grande',  NULL,1,'Dócil e ativa, ótima com crianças.',                              'disponivel'),
(35,35, 3,'Dante',  'Cachorro','Vira-lata',       'Macho', '2023-01-20','Preto',          'Médio',   NULL,1,'Em tratamento de cinomose suspeita.',                             'tratamento'),
(36,36, 3,'Mimi',   'Gato',    'SRD',             'Fêmea', '2021-04-08','Tigrada',        'Pequeno', NULL,1,'Adulta, bem socializada, ótima para apartamento.',                'disponivel'),
(37,37, 3,'Oliver', 'Cachorro','Vira-lata',       'Macho', NULL,        'Caramelo',       'Pequeno', 0,   1,'Filhote que chegou fraco, já se recuperou.',                      'disponivel'),
(38,38, 3,'Magda',  'Cachorro','Cocker Spaniel',  'Fêmea', '2015-07-30','Caramelo',       'Médio',   NULL,1,'Idosa e docinha, precisa de lar tranquilo.',                      'disponivel'),
(39,39, 3,'Sushi',  'Gato',    'SRD',             'Macho', '2020-09-01','Preto',          'Médio',   NULL,1,'Adulto castrado, veio com a irmã Sakura.',                        'disponivel'),
(40,40, 3,'Sakura', 'Gato',    'SRD',             'Fêmea', '2020-09-01','Cinza',          'Médio',   NULL,1,'Adulta castrada, veio com o irmão Sushi.',                        'disponivel'),
(41,41, 3,'Mochi',  'Cachorro','Shih Tzu',        'Macho', NULL,        'Branco e marrom','Pequeno', 0,   1,'Filhote adorável, muito sociável.',                               'disponivel'),
(42,42, 3,'Chanel', 'Gato',    'SRD',             'Fêmea', '2022-01-10','Tigrada',        'Pequeno', NULL,1,'Recuperada de queimaduras nas patas.',                            'disponivel'),
(43,43, 3,'Pippin', 'Gato',    'SRD',             'Macho', '2018-03-20','Laranja',        'Médio',   NULL,1,'Tranquilo e castrado, veio com o irmão.',                         'disponivel'),
(44,44, 3,'Boxer',  'Cachorro','Boxer',           'Macho', '2020-05-05','Caramelo e bco', 'Grande',  NULL,1,'Adulto dócil, encontrado com coleira.',                           'disponivel'),
(45,45, 3,'Spitz',  'Cachorro','Spitz Alemão',    'Fêmea', '2022-08-15','Branco',         'Pequeno', NULL,1,'Após higienização, pelo lindo. Muito afetiva.',                   'disponivel'),
(46,46, 3,'Jasper', 'Gato',    'Angorá',          'Macho', '2019-11-10','Branco e cinza', 'Médio',   NULL,1,'Dócil e vacinado, veio de família que viajou ao exterior.',       'disponivel'),
(47,47, 3,'Cleo',   'Cachorro','Vira-lata',       'Fêmea', '2022-07-20','Caramelo',       'Médio',   NULL,1,'Chegou grávida, filhotes já encaminhados. Pronta p/ adoção.',     'disponivel'),
(48,48, 3,'Félix',  'Gato',    'SRD',             'Macho', '2020-04-12','Preto',          'Médio',   NULL,1,'FIV positivo, necessita de lar exclusivo p/ gatos FIV+.',         'disponivel'),
(49,49, 3,'Sandy',  'Cachorro','Cocker Spaniel',  'Fêmea', '2021-09-05','Caramelo',       'Médio',   NULL,1,'Calma e carinhosa, veio por alergia da tutora.',                  'disponivel'),
(50,50, 3,'Neve',   'Cachorro','Husky Siberiano', 'Fêmea', '2022-11-18','Preto e branco', 'Grande',  NULL,1,'Ativa e linda. Precisa de exercício diário.',                     'disponivel'),
(51,51, 3,'Atlas',  'Cachorro','Vira-lata',       'Macho', '2023-03-01','Marrom',         'Grande',  NULL,1,'Em recuperação de fratura no quadril.',                           'tratamento'),
(52,52, 3,'Mel2',   'Cachorro','Maltês',          'Fêmea', '2019-06-14','Branco',         'Pequeno', NULL,1,'Pequena e carinhosa, castrada e vacinada.',                       'disponivel'),
(53,53, 3,'Hércules','Cachorro','Labrador',       'Macho', '2015-02-28','Amarelo',        'Grande',  NULL,1,'Idoso e muito dócil, precisa de lar tranquilo.',                  'disponivel'),
(54,54, 3,'Perola', 'Gato',    'SRD',             'Fêmea', NULL,        'Branco',         'Pequeno', 0,   1,'Filhote resgatada com a mãe. Mãe adotada juntas.',               'disponivel'),
(55,55, 3,'Guto',   'Cachorro','Golden Retriever','Macho', '2021-10-05','Dourado',        'Grande',  NULL,1,'Dócil e brincalhão, dono transferido para outra cidade.',         'disponivel');

-- -------------------------------------------------------------
-- PRONTUÁRIOS (55)
-- -------------------------------------------------------------
INSERT INTO prontuario (id_prontuario, id_animal, cuidadosEspeciais, comportamento, animalCastrado, observacoes) VALUES
(1, 1,'Nenhum','Muito dócil e sociável',1,NULL),
(2, 2,'Nenhum','Calma e afetuosa',1,NULL),
(3, 3,'Nenhum','Agitado, requer exercício',1,'Totalmente recuperado de atropelamento'),
(4, 4,'Nenhum','Brincalhona e esperta',1,NULL),
(5, 5,'Nenhum','Tranquilo',0,'Adotado'),
(6, 6,'Alimentação especial','Agitada mas carinhosa',0,'Recuperada de debilidade'),
(7, 7,'Nenhum','Muito ativo e brincalhão',1,NULL),
(8, 8,'Nenhum','Independente e elegante',1,NULL),
(9, 9,'Shampoo medicado 2x/sem','Assustada inicialmente',0,'Tratamento dermatológico em andamento'),
(10,10,'Nenhum','Curioso e protetor',0,'Filhote, aguarda castração'),
(11,11,'Nenhum','Silencioso e carinhoso',1,NULL),
(12,12,'Curativo semanal','Tímida',0,'Ferida no focinho em cicatrização'),
(13,13,'Acompanhamento comportamental','Assustada, progredindo',0,'Maus-tratos no passado'),
(14,14,'Nenhum','Energético e curioso',1,NULL),
(15,15,'Nenhum','Dócil e obediente',1,NULL),
(16,16,'Repouso forçado','Dócil, suportou bem cirurgia',0,'Fratura em recuperação'),
(17,17,'Nenhum','Brincalhão e sociável',0,'Filhote, aguarda castração'),
(18,18,'Nenhum','Dócil com tutores',1,'Recuperado de sarna'),
(19,19,'Nenhum','Amorosa e gentil',1,NULL),
(20,20,'Nenhum','Energética e esperta',0,NULL),
(21,21,'Nenhum','Tranquila',1,'Adotada'),
(22,22,'Nenhum','Alegre e ativo',0,NULL),
(23,23,'Nenhum','Calmo e carinhoso',1,NULL),
(24,24,'Nenhum','Leal e inteligente',1,'Adotado'),
(25,25,'Nenhum','Dócil e brincalhão',0,'Filhote, aguarda castração'),
(26,26,'Colírio 3x/dia','Tímida no início',1,'Tratamento concluído'),
(27,27,'Espaço amplo necessário','Dócil e protetor',1,NULL),
(28,28,'Ração sênior','Quieta e tranquila',1,'Animal idoso'),
(29,29,'Nenhum','Brincalhão',0,'Filhote'),
(30,30,'Nenhum','Dócil',0,'Filhote'),
(31,31,'Nenhum','Tranquilo',1,NULL),
(32,32,'Acompanhamento semanal','Protetivo mas dócil',0,'Histórico de maus-tratos'),
(33,33,'Nenhum','Animado e carinhoso',0,'Adotado'),
(34,34,'Nenhum','Dócil e ativa',1,NULL),
(35,35,'Isolamento e medicação','Apático por doença',0,'Cinomose suspeita em tratamento'),
(36,36,'Nenhum','Sociável e independente',1,NULL),
(37,37,'Dieta reforçada','Frágil mas melhorando',0,'Filhote em recuperação'),
(38,38,'Ração sênior, check-up mensal','Tranquila e carinhosa',1,'Animal idoso'),
(39,39,'Nenhum','Curioso e independente',1,NULL),
(40,40,'Nenhum','Adaptável',1,NULL),
(41,41,'Nenhum','Muito sociável',0,'Filhote'),
(42,42,'Curativo nas patas 1x/sem','Mansa apesar da dor',0,'Queimaduras em cicatrização'),
(43,43,'Nenhum','Tranquilo',1,NULL),
(44,44,'Nenhum','Dócil e obediente',1,NULL),
(45,45,'Tosa e higiene regular','Afetiva e curiosa',0,'Pelo restaurado'),
(46,46,'Nenhum','Dócil e vacinado',1,NULL),
(47,47,'Suplementação pós-parto','Recuperando condição física',1,NULL),
(48,48,'Cuidados p/ FIV+','Saudável dentro do quadro',1,'FIV positivo — lar exclusivo'),
(49,49,'Nenhum','Calma e obediente',1,NULL),
(50,50,'Exercício diário obrigatório','Ativa e inteligente',0,'Aguarda castração'),
(51,51,'Repouso e fisioterapia','Corajoso na recuperação',0,'Fratura no quadril'),
(52,52,'Nenhum','Carinhosa e quieta',1,NULL),
(53,53,'Ração sênior, check-up trimestral','Tranquilo e leal',1,'Animal idoso'),
(54,54,'Nenhum','Tímida mas sociável',0,'Filhote'),
(55,55,'Nenhum','Dócil e brincalhão',1,NULL);

-- -------------------------------------------------------------
-- EXAMES (55)
-- -------------------------------------------------------------
INSERT INTO exame (id_exame, observacoesClinicas, temperatura, peso, liberadoAdocao, estadoGeral, dataExame, id_veterinario, id_prontuario) VALUES
(1, 'Saudável, sem alterações clínicas',         38.2,  8.3, 1,'Bom',    '2025-01-10',1,1),
(2, 'Saudável, peso adequado para a raça',        38.4,  3.9, 1,'Bom',    '2025-01-15',2,2),
(3, 'Em recuperação de atropelamento',            38.9, 24.5, 0,'Regular','2025-01-18',1,3),
(4, 'Saudável, apta para adoção',                 38.1,  5.8, 1,'Bom',    '2025-01-22',2,4),
(5, 'Sintomas respiratórios leves',               39.2,  1.8, 0,'Regular','2025-01-26',1,5),
(6, 'Debilitada, iniciando tratamento nutricional',38.8, 2.6, 0,'Regular','2025-02-01',2,6),
(7, 'Ferimento na pata cicatrizando bem',         38.5, 29.0, 1,'Bom',    '2025-02-05',1,7),
(8, 'Saudável, castrada e vacinada',              38.3,  4.2, 1,'Bom',    '2025-02-10',2,8),
(9, 'Sarna em tratamento ativo',                  39.0,  9.1, 0,'Regular','2025-02-15',1,9),
(10,'Filhote saudável, vacinação iniciada',        38.2,  4.5, 1,'Bom',    '2025-02-20',2,10),
(11,'Adulto saudável, em dia com vacinas',         38.3,  5.0, 1,'Bom',    '2025-03-01',1,11),
(12,'Ferida em processo de cicatrização',          38.7,  3.5, 0,'Regular','2025-03-05',2,12),
(13,'Desnutrida, iniciando recuperação',           39.1,  7.2, 0,'Regular','2025-03-10',1,13),
(14,'Saudável, castrado e vacinado',               38.0,  9.8, 1,'Bom',    '2025-03-15',2,14),
(15,'Saudável, vacinação em dia',                  38.2,  4.1, 1,'Bom',    '2025-03-20',1,15),
(16,'Fratura em recuperação pós-cirurgia',         39.0, 22.0, 0,'Regular','2025-03-25',2,16),
(17,'Filhote saudável, recém chegado',             38.1,  0.9, 1,'Bom',    '2025-04-01',1,17),
(18,'Pós-tratamento de sarna, limpo',              38.4, 36.0, 1,'Bom',    '2025-04-05',2,18),
(19,'Saudável, em dia com vacinas',                38.2, 28.5, 1,'Bom',    '2025-04-10',1,19),
(20,'Jovem saudável, apto para adoção',            38.3, 10.2, 1,'Bom',    '2025-04-15',2,20),
(21,'Animal saudável pós-parto',                   38.1,  3.8, 1,'Bom',    '2025-04-20',1,21),
(22,'Jovem e ativo, castração pendente',           38.5, 21.0, 1,'Bom',    '2025-04-25',2,22),
(23,'Adulto saudável, vacinado',                   38.3,  5.5, 1,'Bom',    '2025-05-01',1,23),
(24,'Ferida no pescoço cicatrizada',               38.4, 33.0, 1,'Bom',    '2025-05-05',2,24),
(25,'Filhote em boa condição geral',               38.0,  2.1, 1,'Bom',    '2025-05-10',1,25),
(26,'Conjuntivite em tratamento',                  38.8,  3.6, 0,'Regular','2025-05-15',2,26),
(27,'Grande porte, saudável',                      38.2, 58.0, 1,'Bom',    '2025-05-20',1,27),
(28,'Idosa, exames de rotina OK',                  38.4,  4.2, 1,'Bom',    '2025-05-25',2,28),
(29,'Filhote saudável',                            38.1,  1.8, 1,'Bom',    '2025-06-01',1,29),
(30,'Filhote saudável',                            38.0,  1.6, 1,'Bom',    '2025-06-05',2,30),
(31,'Castrado e vacinado, saudável',               38.3,  5.1, 1,'Bom',    '2025-06-10',1,31),
(32,'Costelas em recuperação',                     39.2, 42.0, 0,'Regular','2025-06-15',2,32),
(33,'Filhote animado, saudável',                   38.0,  6.5, 1,'Bom',    '2025-06-20',1,33),
(34,'Saudável e ativa',                            38.3, 25.5, 1,'Bom',    '2025-06-25',2,34),
(35,'Cinomose confirmada, em tratamento',          40.1, 18.0, 0,'Crítico','2025-07-01',1,35),
(36,'Saudável, vacinada e castrada',               38.2,  3.9, 1,'Bom',    '2025-07-05',2,36),
(37,'Filhote fraco, dieta reforçada',              38.5,  1.2, 0,'Regular','2025-07-10',1,37),
(38,'Idosa, check-up anual OK',                    38.3, 10.5, 1,'Bom',    '2025-07-15',2,38),
(39,'Adulto saudável e castrado',                  38.4,  4.3, 1,'Bom',    '2025-07-20',1,39),
(40,'Saudável após período de adaptação',          38.3,  4.1, 1,'Bom',    '2025-07-25',2,40),
(41,'Filhote saudável',                            38.1,  0.8, 1,'Bom',    '2025-08-01',1,41),
(42,'Queimaduras nas patas em cicatrização',       38.6,  3.7, 0,'Regular','2025-08-05',2,42),
(43,'Adulto castrado e saudável',                  38.2,  4.9, 1,'Bom',    '2025-08-10',1,43),
(44,'Adulto dócil, saudável',                      38.3, 30.0, 1,'Bom',    '2025-08-15',2,44),
(45,'Pelo restaurado, saudável',                   38.1,  8.5, 1,'Bom',    '2025-08-20',1,45),
(46,'Castrado e vacinado, saudável',               38.4,  5.2, 1,'Bom',    '2025-08-25',2,46),
(47,'Pós-parto, em recuperação',                   38.5, 11.0, 0,'Regular','2025-09-01',1,47),
(48,'FIV+ estável, sem sintomas ativos',           38.2,  4.1, 1,'Bom',    '2025-09-05',2,48),
(49,'Saudável, alérgeno removido',                 38.3,  9.8, 1,'Bom',    '2025-09-10',1,49),
(50,'Saudável, ativa e bem alimentada',            38.1, 20.5, 1,'Bom',    '2025-09-15',2,50),
(51,'Fratura no quadril, pós-cirurgia',            39.1, 28.0, 0,'Regular','2025-10-05',1,51),
(52,'Pequena, saudável, castrada',                 38.2,  3.2, 1,'Bom',    '2025-10-10',2,52),
(53,'Idoso, exames laboratoriais OK',              38.4, 32.0, 1,'Bom',    '2025-10-15',1,53),
(54,'Filhote frágil, melhorando',                  38.0,  0.7, 0,'Regular','2025-12-05',2,54),
(55,'Adulto saudável e vacinado',                  38.3, 27.5, 1,'Bom',    '2025-12-20',1,55);

-- -------------------------------------------------------------
-- VACINAS E VERMIFUGAÇÕES (amostras)
-- -------------------------------------------------------------
INSERT INTO vacina (id_vacina, loteVacina, tipoVacina, fabricante, nomeVacina) VALUES
(1,'L123','Antirrábica',      'Zoetis',          'RaivaPet'),
(2,'L456','V8',               'Vetnil',           'V8 Canina'),
(3,'L789','V10',              'MSD Saúde Animal', 'V10 Plus'),
(4,'L321','Giardíase',        'Vetnil',           'GiardiaVet'),
(5,'L654','Leishmaniose',     'Ceva',             'LeishTec'),
(6,'L987','Viral Felina',     'Zoetis',           'FelVax'),
(7,'L741','V4 Felina',        'MSD Saúde Animal', 'Quadruple Cat'),
(8,'L852','V3 Felina',        'Ourofino',         'Triple Cat'),
(9,'L963','Tosse dos Canis',  'Ceva',             'BronchiDog'),
(10,'L159','Polivalente Filhote','Vetnil',         'Puppy Dose');

INSERT INTO vacinacao (id_vacinacao, id_exame, id_vacina, observacao, data_aplicacao) VALUES
(1, 1, 2,'V8 aplicada sem reações','2025-01-10'),
(2, 2, 6,'Vacina felina aplicada','2025-01-15'),
(3, 4, 1,'Antirrábica e V8 aplicadas','2025-01-22'),
(4, 7, 2,'Reforço V8','2025-02-05'),
(5, 8, 7,'V4 felina','2025-02-10'),
(6,10,10,'Polivalente filhote','2025-02-20'),
(7,11, 6,'Viral felina reforço anual','2025-03-01'),
(8,14, 2,'V8 anual','2025-03-15'),
(9,15, 1,'Antirrábica anual','2025-03-20'),
(10,19,3,'V10 sem reações','2025-04-10'),
(11,23,2,'V8 reforço','2025-05-01'),
(12,27,1,'Antirrábica','2025-05-20'),
(13,28,6,'Felina reforço','2025-05-25'),
(14,31,7,'V4 felina anual','2025-06-10'),
(15,34,3,'V10 anual','2025-06-25');

INSERT INTO remedio (id_remedio, fabricante, especieIndicada, principioAtivo, viaAdministracao, dosagemRecomendada, loteRemedio, nomeComercial, frequencia) VALUES
(1,'Vetnil','Cachorro','Ivermectina','Oral','1 comprimido','R123','VermiPet','Dose única'),
(2,'Bayer','Cachorro','Praziquantel','Oral','1 comprimido','R456','Drontal','A cada 3 meses'),
(3,'Virbac','Cachorro','Febantel','Oral','1 comprimido','R789','Endogard','Dose única'),
(4,'Ceva','Cachorro','Pamoato de Pirantel','Oral','1 comprimido','R321','Canex','Dose única'),
(5,'Ourofino','Cachorro','Fenbendazol','Oral','1 comprimido','R654','Fenzol Pet','3 dias consecutivos'),
(6,'Vetnil','Cachorro','Metronidazol','Oral','2 comprimidos','R987','Giardicid','12/12h 5 dias'),
(7,'Zoetis','Gato','Praziquantel','Oral','1 comprimido','R741','Cat Vermi','Dose única'),
(8,'MSD Saúde Animal','Gato','Fenbendazol','Oral','1 comprimido','R852','Feline Guard','3 dias consecutivos'),
(9,'Vetnil','Cachorro','Ivermectina','Tópico','5 gotas','R963','Top Verm','Dose única'),
(10,'Ceva','Cachorro','Associação','Oral','1 comprimido','R159','MultiVerm','A cada 6 meses');

INSERT INTO vermifugacao (id_vermifugacao, id_exame, dosagem, id_remedio, data_aplicacao) VALUES
(1, 1,'1 comprimido',1,'2025-01-10'),
(2, 2,'1 comprimido',7,'2025-01-15'),
(3, 3,'1 comprimido',2,'2025-01-18'),
(4, 4,'1 comprimido',3,'2025-01-22'),
(5, 6,'2 comprimidos',6,'2025-02-01'),
(6, 7,'1 comprimido',5,'2025-02-05'),
(7, 8,'1 comprimido',8,'2025-02-10'),
(8,10,'1 comprimido',4,'2025-02-20'),
(9,14,'1 comprimido',2,'2025-03-15'),
(10,19,'1 comprimido',3,'2025-04-10');

-- -------------------------------------------------------------
-- ADOÇÕES (12 — com 2 apoiadores tendo múltiplas interações)
-- -------------------------------------------------------------
INSERT INTO adocao (id_adocao, id_usuario, dataSolicitacao, id_animal, dataAdocao, id_statusAdocao, termoResponsabilidade) VALUES
-- Aprovadas (5)
(1, 6,'2025-02-10',5, '2025-02-15',2,'Tenho espaço, experiência e total disponibilidade para cuidar. Me comprometo com saúde e bem-estar do animal.'),
(2, 7,'2025-03-01',7, '2025-03-05',2,'Tenho quintal e histórico com cães de grande porte. Assumo total responsabilidade pelo animal.'),
(3, 6,'2025-04-18',21,'2025-04-22',2,'Família estruturada com espaço. Já tivemos gatos antes. Me comprometo com todos os cuidados.'),
(4, 7,'2025-05-10',24,'2025-05-15',2,'Tenho experiência com Pastor Alemão. Casa com quintal e rotina de exercícios garantida.'),
(5, 6,'2025-08-01',33,'2025-08-06',2,'Golden era o sonho da minha família. Temos tudo pronto para recebê-lo com muito amor.'),
-- Pendentes (4)
(6, 6,'2026-06-01',1, NULL,1,'Tenho casa ampla e sempre quis um cachorro caramelo. Me comprometo com todos os cuidados necessários.'),
(7, 7,'2026-06-03',19,NULL,1,'Família com crianças e quintal. A Meg parece perfeita para nós. Já tivemos Golden antes.'),
(8, 6,'2026-06-05',27,NULL,1,'Tenho espaço e São Bernardo sempre foi meu sonho. Pesquisei muito sobre a raça.'),
(9, 7,'2026-06-08',55,NULL,1,'Dócil e brincalhão é tudo o que quero. Tenho horários flexíveis para cuidar bem.'),
-- Recusadas (3)
(10,7,'2025-04-01',3, NULL,3,'Tenho interesse no Thor para minha família, temos espaço em casa.'),
(11,6,'2025-06-15',13,NULL,3,'Quero adotar a Brisa, tenho espaço e carinho para oferecer.'),
(12,7,'2025-09-10',35,NULL,3,'Gostaria do Dante para companhia, tenho apartamento.');

-- -------------------------------------------------------------
-- DOAÇÕES (8)
-- -------------------------------------------------------------
INSERT INTO doacao (id_doacao, id_tipoDoacao, id_usuario, valor, dataDoacao, notaFiscal) VALUES
(1,1,6, 200.00,'2025-02-01','NF-001'),
(2,2,7, NULL,  '2025-03-15','NF-002'),
(3,1,6, 350.00,'2025-05-01','NF-003'),
(4,1,7, 150.00,'2025-07-20','NF-004'),
(5,1,6, 500.00,'2025-10-05','NF-005'),
(6,2,7, NULL,  '2025-11-10','NF-006'),
(7,1,6, 300.00,'2026-02-01','NF-007'),
(8,1,7, 400.00,'2026-05-15','NF-008');

-- -------------------------------------------------------------
-- FINANCEIRO (55 lançamentos — jan/2025 a jun/2026)
-- -------------------------------------------------------------
INSERT INTO financeiro (id_financeiro, id_categoriaFinanceira, id_statusPagamento, id_formaPagamento, tipoMovimentacao, valor, descricao, dataMovimentacao, dataRegistro) VALUES
(1, 1,2,2,'Entrada', 200.00,'Doação — Guilherme Trombini',              '2025-01-08','2025-01-08'),
(2, 2,2,1,'Saida',   280.00,'Ração cães adultos — 20kg',                '2025-01-12','2025-01-12'),
(3, 3,2,1,'Saida',   350.00,'Consultas veterinárias lote jan',          '2025-01-20','2025-01-20'),
(4, 1,2,2,'Entrada', 350.00,'Doação — Mariana Souza',                   '2025-02-03','2025-02-03'),
(5, 1,2,5,'Entrada', 800.00,'Doação empresa — TudoPet',                 '2025-02-10','2025-02-10'),
(6, 4,2,1,'Saida',   190.00,'Vacinas lote fevereiro',                   '2025-02-14','2025-02-14'),
(7, 2,2,1,'Saida',   240.00,'Ração gatos — 15kg',                       '2025-02-20','2025-02-20'),
(8, 1,2,2,'Entrada', 150.00,'Doação online — campanha fev',             '2025-02-25','2025-02-25'),
(9, 6,2,1,'Entrada', 420.00,'Arrecadação feira de adoção — março',      '2025-03-08','2025-03-08'),
(10,3,2,1,'Saida',   680.00,'Cirurgia Thor — fratura atropelamento',    '2025-03-10','2025-03-10'),
(11,5,2,5,'Saida',   310.00,'Reforma canil — pintura e grades',         '2025-03-18','2025-03-18'),
(12,1,2,2,'Entrada', 500.00,'Doação — Guilherme Trombini',              '2025-04-02','2025-04-02'),
(13,1,2,4,'Entrada',1200.00,'Doação empresa — Tech4Good',               '2025-04-10','2025-04-10'),
(14,2,2,1,'Saida',   320.00,'Ração premium cães — reposição',           '2025-04-15','2025-04-15'),
(15,4,2,1,'Saida',   230.00,'Antipulgas e vermífugo lote abril',        '2025-04-22','2025-04-22'),
(16,1,2,2,'Entrada', 750.00,'Doação — Mariana Souza',                   '2025-05-05','2025-05-05'),
(17,6,2,1,'Entrada', 560.00,'Bingo beneficente — arrecadação',          '2025-05-15','2025-05-15'),
(18,3,2,1,'Saida',   490.00,'Castração lote maio — 5 animais',          '2025-05-10','2025-05-10'),
(19,2,2,3,'Saida',   275.00,'Ração filhotes — 10kg',                    '2025-05-20','2025-05-20'),
(20,8,2,1,'Saida',   120.00,'Material de limpeza e higiene',            '2025-05-28','2025-05-28'),
(21,1,2,2,'Entrada', 300.00,'Doação — Guilherme Trombini',              '2025-06-02','2025-06-02'),
(22,1,2,5,'Entrada',2000.00,'Doação institucional — Prefeitura',        '2025-06-15','2025-06-15'),
(23,5,2,1,'Saida',   450.00,'Compra camas e cobertores — 15 unid.',     '2025-06-08','2025-06-08'),
(24,3,2,1,'Saida',   540.00,'Check-up semestral — 12 animais',          '2025-06-20','2025-06-20'),
(25,1,2,2,'Entrada', 900.00,'Doação — Mariana Souza',                   '2025-07-05','2025-07-05'),
(26,4,2,1,'Saida',   370.00,'Vacinas e medicamentos julho',             '2025-07-15','2025-07-15'),
(27,2,2,1,'Saida',   310.00,'Ração reposição julho',                    '2025-07-22','2025-07-22'),
(28,6,2,1,'Entrada', 730.00,'Arrecadação leilão solidário',             '2025-08-10','2025-08-10'),
(29,3,2,1,'Saida',   480.00,'Tratamento cinomose — medicamentos',       '2025-08-05','2025-08-05'),
(30,5,2,5,'Saida',   280.00,'Ampliação do gatil — materiais',           '2025-08-18','2025-08-18'),
(31,1,2,2,'Entrada', 400.00,'Doação — campanha Dia dos Animais',        '2025-09-01','2025-09-01'),
(32,2,2,1,'Saida',   290.00,'Ração setembro — reposição',               '2025-09-15','2025-09-15'),
(33,4,2,1,'Saida',   210.00,'Antipulgas setembro',                      '2025-09-22','2025-09-22'),
(34,1,2,4,'Entrada',1500.00,'Campanha fim de ano — doações online',     '2025-12-10','2025-12-10'),
(35,3,2,1,'Saida',   620.00,'Check-up semestral dezembro',              '2025-12-05','2025-12-05'),
(36,8,2,1,'Saida',   180.00,'Materiais de escritório e admin',          '2025-12-20','2025-12-20'),
(37,1,2,2,'Entrada', 600.00,'Doação — Guilherme Trombini',              '2026-01-08','2026-01-08'),
(38,3,2,1,'Saida',   550.00,'Consultas jan/2026 — lote',                '2026-01-15','2026-01-15'),
(39,1,2,5,'Entrada',1800.00,'Doação empresa — PetLife',                 '2026-02-05','2026-02-05'),
(40,2,2,2,'Saida',   390.00,'Ração reposição fevereiro',                '2026-02-12','2026-02-12'),
(41,6,2,1,'Entrada', 950.00,'Feira de adoção fev/2026',                 '2026-02-22','2026-02-22'),
(42,4,2,1,'Saida',   280.00,'Vacinas lote março/2026',                  '2026-03-10','2026-03-10'),
(43,1,2,2,'Entrada', 700.00,'Campanha Dia Mundial dos Animais',         '2026-03-15','2026-03-15'),
(44,5,2,5,'Saida',   750.00,'Ampliação canil — materiais',              '2026-04-05','2026-04-05'),
(45,3,2,1,'Saida',   480.00,'Consultas abril/2026',                     '2026-04-18','2026-04-18'),
(46,1,2,2,'Entrada', 450.00,'Doação — Mariana Souza',                   '2026-05-02','2026-05-02'),
(47,2,2,1,'Saida',   310.00,'Ração maio — reposição',                   '2026-05-10','2026-05-10'),
(48,4,2,1,'Saida',   195.00,'Vermífugos e antipulgas maio',             '2026-05-18','2026-05-18'),
(49,1,2,2,'Entrada', 800.00,'Doação — campanha junho',                  '2026-06-02','2026-06-02'),
(50,2,2,1,'Saida',   295.00,'Ração junho — reposição',                  '2026-06-05','2026-06-05'),
(51,3,2,1,'Saida',   420.00,'Consultas junho/2026',                     '2026-06-10','2026-06-10'),
(52,1,1,NULL,'Entrada',500.00,'Doação pendente — Guilherme Trombini',   '2026-06-12','2026-06-12'),
(53,1,1,NULL,'Entrada',350.00,'Doação pendente — Mariana Souza',        '2026-06-14','2026-06-14'),
(54,7,2,2,'Saida',   180.00,'Impressão de cartazes e divulgação',       '2026-06-15','2026-06-15'),
(55,8,2,1,'Saida',    95.00,'Materiais de escritório junho',            '2026-06-18','2026-06-18');

-- -------------------------------------------------------------
-- PRODUTOS (10)
-- -------------------------------------------------------------
INSERT INTO produto (id_produto, id_categoriaProduto, nomeProduto, marca, unidadeMedida, descricao) VALUES
(1, 1,'Ração Premium Cão Adulto',   'Pedigree',  'kg',     'Ração para cães adultos de médio e grande porte'),
(2, 1,'Ração Premium Cão Filhote',  'Pedigree',  'kg',     'Ração com nutrientes essenciais para filhotes'),
(3, 1,'Ração Premium Gato Adulto',  'Whiskas',   'kg',     'Ração completa para gatos adultos'),
(4, 1,'Ração Premium Gato Filhote', 'Whiskas',   'kg',     'Ração para gatinhos em fase de crescimento'),
(5, 2,'Vermífugo Cão',              'Drontal',   'unidade','Vermífugo oral dose única para cães'),
(6, 2,'Antipulgas Spot-on Cão',     'Frontline', 'unidade','Pipeta antipulgas para cães — 1 mês de ação'),
(7, 2,'Antibiótico Amoxicilina',    'Genérico',  'unidade','Uso veterinário sob prescrição'),
(8, 3,'Shampoo Neutro Pet',         'PetClean',  'unidade','Shampoo suave para banho de cães e gatos'),
(9, 3,'Desinfetante Canil',         'BioVet',    'litro',  'Desinfetante para limpeza de canis e gatil'),
(10,4,'Coleira Nylon Ajustável',    'PetMax',    'unidade','Coleira ajustável para cães de todos portes');

-- -------------------------------------------------------------
-- ESTOQUE (10)
-- -------------------------------------------------------------
INSERT INTO estoque (id_estoque, id_produto, quantidadeAtual, quantidadeMinima, custoUnitario, lote, tipoOrigem, dataCriacao, dataUltimaEntrada, dataValidade) VALUES
(1,  1, 42, 10, 20.00,'L001','Doação', '2025-01-10','2026-05-15',NULL),
(2,  2,  6,  5, 22.00,'L002','Compra', '2025-01-10','2026-03-01',NULL),
(3,  3, 28,  8, 18.00,'L003','Doação', '2025-01-15','2026-04-10',NULL),
(4,  4,  2,  5, 20.00,'L004','Compra', '2025-02-01','2026-02-01',NULL),
(5,  5, 72, 20,  3.50,'L005','Compra', '2025-02-10','2026-06-01','2027-06-01'),
(6,  6, 14, 10, 19.90,'L006','Compra', '2025-02-15','2026-05-01','2026-10-15'),
(7,  7,  4, 10,  6.00,'L007','Compra', '2025-03-01','2026-03-01','2026-09-01'),
(8,  8, 12,  5, 14.50,'L008','Compra', '2025-03-10','2026-04-20',NULL),
(9,  9,  4,  3, 21.00,'L009','Compra', '2025-04-01','2026-04-01',NULL),
(10,10,  1,  5, 12.00,'L010','Compra', '2025-04-10','2026-04-10',NULL);

-- -------------------------------------------------------------
-- MOVIMENTAÇÕES DE ESTOQUE (55)
-- -------------------------------------------------------------
INSERT INTO movimentacaoestoque (id_estoque, tipoMovimentacao, quantidade, valor, descricao, dataMovimentacao) VALUES
-- Entradas iniciais (estoque inicial)
(1, 'Entrada',60,1200.00,'Cadastro inicial via doação',             '2025-01-10'),
(2, 'Entrada',15, 330.00,'Cadastro inicial — compra filhotes',      '2025-01-10'),
(3, 'Entrada',40, 720.00,'Cadastro inicial via doação gatos',       '2025-01-15'),
(4, 'Entrada',10, 200.00,'Cadastro inicial — compra gatil',         '2025-02-01'),
(5, 'Entrada',100,350.00,'Compra lote vermífugos',                  '2025-02-10'),
(6, 'Entrada',25, 497.50,'Compra antipulgas trimestral',            '2025-02-15'),
(7, 'Entrada',20, 120.00,'Compra antibióticos — lote 1',            '2025-03-01'),
(8, 'Entrada',20, 290.00,'Compra shampoos pet',                     '2025-03-10'),
(9, 'Entrada', 8, 168.00,'Compra desinfetante canil',               '2025-04-01'),
(10,'Entrada',10, 120.00,'Compra coleiras ajustáveis',              '2025-04-10'),
-- Saídas jan/fev 2025
(1, 'Saida',  5, 100.00,'Consumo semanal — cães adultos',          '2025-01-20'),
(3, 'Saida',  4,  72.00,'Consumo semanal — gatos',                 '2025-01-25'),
(5, 'Saida', 10,  35.00,'Vermifugação lote janeiro',               '2025-01-28'),
(1, 'Saida',  5, 100.00,'Consumo fevereiro — cães',                '2025-02-10'),
(3, 'Saida',  3,  54.00,'Consumo fevereiro — gatos',               '2025-02-15'),
(6, 'Saida',  5,  99.50,'Antipulgas aplicados — fevereiro',        '2025-02-22'),
-- Saídas mar/abr 2025
(7, 'Saida',  8,  48.00,'Antibiótico — tratamento 4 animais',      '2025-03-05'),
(8, 'Saida',  4,  58.00,'Shampoo — banhos semanais',               '2025-03-15'),
(1, 'Saida',  6, 120.00,'Consumo março — cães',                    '2025-03-20'),
(5, 'Saida', 12,  42.00,'Vermifugação lote março',                 '2025-03-25'),
(2, 'Saida',  5, 110.00,'Filhotes — consumo março',                '2025-03-28'),
(10,'Saida',  8,  96.00,'Coleiras colocadas em animais',           '2025-04-05'),
(6, 'Saida',  3,  59.70,'Antipulgas abril',                        '2025-04-18'),
(9, 'Saida',  2,  42.00,'Desinfetante — limpeza canil',            '2025-04-25'),
-- Saídas mai/jun 2025
(1, 'Saida',  6, 120.00,'Consumo maio — cães',                     '2025-05-10'),
(3, 'Saida',  4,  72.00,'Consumo maio — gatos',                    '2025-05-15'),
(5, 'Saida',  8,  28.00,'Vermifugação lote maio',                  '2025-05-20'),
(8, 'Saida',  3,  43.50,'Shampoo — banhos maio',                   '2025-05-25'),
(7, 'Saida',  5,  30.00,'Antibiótico tratamento — cinomose',       '2025-06-01'),
(1, 'Saida',  5, 100.00,'Consumo junho — cães',                    '2025-06-10'),
-- Reposições mid-year 2025
(1, 'Entrada',30, 600.00,'Reposição ração cão — junho',            '2025-06-15'),
(3, 'Entrada',15, 270.00,'Reposição ração gato — junho',           '2025-06-20'),
(5, 'Entrada',50, 175.00,'Reposição vermífugos — julho',           '2025-07-05'),
(6, 'Entrada',15, 298.50,'Reposição antipulgas — julho',           '2025-07-10'),
-- Saídas jul-set 2025
(1, 'Saida',  7, 140.00,'Consumo julho — cães',                    '2025-07-20'),
(3, 'Saida',  5,  90.00,'Consumo julho — gatos',                   '2025-07-25'),
(5, 'Saida', 10,  35.00,'Vermifugação julho',                      '2025-07-28'),
(6, 'Saida',  4,  79.60,'Antipulgas agosto',                       '2025-08-10'),
(9, 'Saida',  2,  42.00,'Desinfetante — limpeza geral agosto',     '2025-08-20'),
(2, 'Saida',  4,  88.00,'Ração filhotes agosto',                   '2025-08-25'),
(1, 'Saida',  6, 120.00,'Consumo agosto — cães',                   '2025-08-30'),
(8, 'Saida',  3,  43.50,'Shampoo banhos setembro',                 '2025-09-15'),
-- Reposições set-dez 2025
(1, 'Entrada',25, 500.00,'Reposição ração cão — outubro',          '2025-10-01'),
(3, 'Entrada',10, 180.00,'Reposição ração gato — outubro',         '2025-10-05'),
(5, 'Entrada',30, 105.00,'Reposição vermífugos — novembro',        '2025-11-01'),
(7, 'Entrada',15,  90.00,'Reposição antibióticos — novembro',      '2025-11-10'),
-- Saídas out-dez 2025
(1, 'Saida',  8, 160.00,'Consumo out/nov — cães',                  '2025-11-20'),
(3, 'Saida',  4,  72.00,'Consumo out/nov — gatos',                 '2025-11-25'),
(7, 'Saida',  6,  36.00,'Antibiótico tratamentos dez',             '2025-12-05'),
-- Reposições e saídas 2026
(1, 'Entrada',20, 400.00,'Reposição ração cão — jan/2026',         '2026-01-10'),
(3, 'Entrada',10, 180.00,'Reposição ração gato — jan/2026',        '2026-01-15'),
(5, 'Entrada',30, 105.00,'Reposição vermífugos — março/2026',      '2026-03-01'),
(6, 'Entrada',10, 199.00,'Reposição antipulgas — março/2026',      '2026-03-15'),
(1, 'Saida',  6, 120.00,'Consumo abr/mai 2026 — cães',             '2026-05-15'),
(3, 'Saida',  3,  54.00,'Consumo abr/mai 2026 — gatos',            '2026-05-20');

-- -------------------------------------------------------------
-- LOGS DE AUDITORIA (55)
-- -------------------------------------------------------------
INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, descricao, ip_origem) VALUES
(2,'LOGIN','usuario',2,'Login: Lucas das Neves Bordignon Pinto (ONG)','127.0.0.1'),
(3,'LOGIN','usuario',3,'Login: Patas do Bem (ONG)','127.0.0.1'),
(1,'LOGIN','usuario',1,'Login: Admin Master (Administrador)','127.0.0.1'),
(2,'CADASTRO_ANIMAL','animal',1,'Animal cadastrado: Rexona (Cachorro)','127.0.0.1'),
(2,'CADASTRO_ANIMAL','animal',2,'Animal cadastrado: Luna (Gato)','127.0.0.1'),
(2,'CADASTRO_ANIMAL','animal',3,'Animal cadastrado: Thor (Cachorro)','127.0.0.1'),
(2,'CADASTRO_ANIMAL','animal',9,'Animal cadastrado: Amora (Cachorro)','127.0.0.1'),
(2,'CADASTRO_ANIMAL','animal',10,'Animal cadastrado: Rex (Cachorro)','127.0.0.1'),
(2,'CADASTRO_ANIMAL','animal',16,'Animal cadastrado: Ares (Cachorro)','127.0.0.1'),
(3,'CADASTRO_ANIMAL','animal',29,'Animal cadastrado: Fofo (Cachorro)','127.0.0.1'),
(3,'CADASTRO_ANIMAL','animal',35,'Animal cadastrado: Dante (Cachorro)','127.0.0.1'),
(3,'CADASTRO_ANIMAL','animal',50,'Animal cadastrado: Neve (Cachorro)','127.0.0.1'),
(3,'CADASTRO_ANIMAL','animal',55,'Animal cadastrado: Guto (Cachorro)','127.0.0.1'),
(6,'INTERESSE_ADOCAO','adocao',1,'Solicitação de adoção para animal ID: 5','127.0.0.1'),
(2,'ADOCAO_APROVADA','adocao',1,'Adoção ID 1 (aprovar) — animal ID: 5','127.0.0.1'),
(2,'STATUS_ANIMAL','animal',5,'Status alterado para: adotado (animal ID: 5)','127.0.0.1'),
(7,'INTERESSE_ADOCAO','adocao',2,'Solicitação de adoção para animal ID: 7','127.0.0.1'),
(2,'ADOCAO_APROVADA','adocao',2,'Adoção ID 2 (aprovar) — animal ID: 7','127.0.0.1'),
(2,'STATUS_ANIMAL','animal',7,'Status alterado para: adotado (animal ID: 7)','127.0.0.1'),
(6,'INTERESSE_ADOCAO','adocao',3,'Solicitação de adoção para animal ID: 21','127.0.0.1'),
(2,'ADOCAO_APROVADA','adocao',3,'Adoção ID 3 (aprovar) — animal ID: 21','127.0.0.1'),
(7,'INTERESSE_ADOCAO','adocao',4,'Solicitação de adoção para animal ID: 24','127.0.0.1'),
(2,'ADOCAO_APROVADA','adocao',4,'Adoção ID 4 (aprovar) — animal ID: 24','127.0.0.1'),
(6,'INTERESSE_ADOCAO','adocao',5,'Solicitação de adoção para animal ID: 33','127.0.0.1'),
(3,'ADOCAO_APROVADA','adocao',5,'Adoção ID 5 (aprovar) — animal ID: 33','127.0.0.1'),
(7,'INTERESSE_ADOCAO','adocao',10,'Solicitação de adoção para animal ID: 3','127.0.0.1'),
(2,'ADOCAO_REJEITADA','adocao',10,'Adoção ID 10 (reprovar) — animal ID: 3','127.0.0.1'),
(6,'INTERESSE_ADOCAO','adocao',11,'Solicitação de adoção para animal ID: 13','127.0.0.1'),
(2,'ADOCAO_REJEITADA','adocao',11,'Adoção ID 11 (reprovar) — animal ID: 13','127.0.0.1'),
(2,'CADASTRO_FINANCEIRO','financeiro',1,'Lançamento Entrada: R$ 200.00 — Doação Guilherme','127.0.0.1'),
(2,'CADASTRO_FINANCEIRO','financeiro',5,'Lançamento Entrada: R$ 800.00 — TudoPet','127.0.0.1'),
(2,'CADASTRO_FINANCEIRO','financeiro',13,'Lançamento Entrada: R$ 1200.00 — Tech4Good','127.0.0.1'),
(2,'CADASTRO_FINANCEIRO','financeiro',22,'Lançamento Entrada: R$ 2000.00 — Prefeitura','127.0.0.1'),
(2,'CADASTRO_FINANCEIRO','financeiro',34,'Lançamento Entrada: R$ 1500.00 — campanha fim de ano','127.0.0.1'),
(2,'CADASTRO_FINANCEIRO','financeiro',39,'Lançamento Entrada: R$ 1800.00 — PetLife','127.0.0.1'),
(2,'CADASTRO_ESTOQUE','estoque',1,'Item cadastrado: Ração Premium Cão Adulto','127.0.0.1'),
(2,'CADASTRO_ESTOQUE','estoque',3,'Item cadastrado: Ração Premium Gato Adulto','127.0.0.1'),
(2,'CADASTRO_ESTOQUE','estoque',5,'Item cadastrado: Vermífugo Cão','127.0.0.1'),
(2,'MOVIMENTACAO_ESTOQUE','estoque',1,'Movimentação Entrada: 60 unidades — estoque inicial','127.0.0.1'),
(2,'MOVIMENTACAO_ESTOQUE','estoque',5,'Movimentação Saida: 10 unidades — vermifugação jan','127.0.0.1'),
(2,'MOVIMENTACAO_ESTOQUE','estoque',6,'Movimentação Saida: 5 unidades — antipulgas fev','127.0.0.1'),
(2,'MOVIMENTACAO_ESTOQUE','estoque',1,'Movimentação Entrada: 30 unidades — reposição jun','127.0.0.1'),
(2,'EDICAO_ANIMAL','animal',9,'Animal editado: Amora — status atualizado','127.0.0.1'),
(2,'STATUS_ANIMAL','animal',12,'Status alterado para: tratamento (animal ID: 12)','127.0.0.1'),
(2,'STATUS_ANIMAL','animal',16,'Status alterado para: tratamento (animal ID: 16)','127.0.0.1'),
(3,'STATUS_ANIMAL','animal',35,'Status alterado para: tratamento (animal ID: 35)','127.0.0.1'),
(3,'STATUS_ANIMAL','animal',51,'Status alterado para: tratamento (animal ID: 51)','127.0.0.1'),
(1,'DESATIVACAO_USUARIO','usuario',6,'Conta desativada (ID: 6)','127.0.0.1'),
(1,'REATIVACAO_USUARIO','usuario',6,'Conta reativada (ID: 6)','127.0.0.1'),
(2,'LOGIN','usuario',2,'Login: Lucas das Neves Bordignon Pinto (ONG)','127.0.0.1'),
(3,'LOGIN','usuario',3,'Login: Patas do Bem (ONG)','127.0.0.1'),
(6,'LOGIN','usuario',6,'Login: Guilherme Trombini (Apoiador)','127.0.0.1'),
(7,'LOGIN','usuario',7,'Login: Mariana Souza (Apoiador)','127.0.0.1'),
(2,'LOGIN_FALHA','usuario',NULL,'Tentativa de login inválida para e-mail: teste@teste.com','127.0.0.1'),
(1,'LOGIN','usuario',1,'Login: Admin Master (Administrador)','127.0.0.1'),
(3,'MOVIMENTACAO_ESTOQUE','estoque',3,'Movimentação Entrada: 10 unidades — reposição ração gato','127.0.0.1');

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- RESUMO — senha: aumigos123
--
-- admin@aumigos.com               → Admin        (id=1)
-- lucasbordignon2011@hotmail.com  → ONG          (id=2) — 28 animais
-- patasbem@email.com              → ONG          (id=3) — 27 animais
-- carlos.lima@vet.com             → Veterinário  (id=4)
-- maria.santos@vet.com            → Veterinária  (id=5)
-- guicastroyt@gmail.com           → Apoiador     (id=6)
-- mariana.souza@email.com         → Apoiador     (id=7)
--
-- 55 animais | 55 entradas | 55 prontuários | 55 exames
-- 55 financeiro | 55 movimentações estoque | 55 logs
-- 12 adoções | 10 produtos | 10 itens estoque
-- =============================================================
