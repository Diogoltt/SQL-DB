CREATE TABLE aluno (
    idt_aluno INT NOT NULL,
    des_nome VARCHAR(255),
    num_grau INT,
    PRIMARY KEY (idt_aluno)
);

CREATE TABLE amigo (
    idt_aluno1 INT NOT NULL,
    idt_aluno2 INT NOT NULL,
    FOREIGN KEY (idt_aluno1) REFERENCES aluno (idt_aluno),
    FOREIGN KEY (idt_aluno2) REFERENCES aluno (idt_aluno)
);

CREATE TABLE curtida (
    idt_aluno1 INT NOT NULL,
    idt_aluno2 INT NOT NULL,
    FOREIGN KEY (idt_aluno1) REFERENCES aluno (idt_aluno),
    FOREIGN KEY (idt_aluno2) REFERENCES aluno (idt_aluno)
);

INSERT INTO aluno (idt_aluno, des_nome, num_grau) VALUES
(1, 'Alice', 10),
(2, 'Bob', 8),
(3, 'Carol', 9),
(4, 'David', 7),
(5, 'Eve', 6);

INSERT INTO amigo (idt_aluno1, idt_aluno2) VALUES
(1, 2), -- Alice e Bob são amigos
(2, 3), -- Bob e Carol são amigos
(3, 4), -- Carol e David são amigos
(4, 5), -- David e Eve são amigos
(1, 3); -- Alice e Carol são amigos

INSERT INTO curtida (idt_aluno1, idt_aluno2) VALUES
(1, 2), -- Alice curtiu Bob
(2, 3), -- Bob curtiu Carol
(3, 1), -- Carol curtiu Alice
(4, 2), -- David curtiu Bob
(5, 4); -- Eve curtiu David

-- Consultas

-- Consultar amigos usando INNER JOIN
SELECT 
    a1.des_nome AS nome_amigo1,
    a2.des_nome AS nome_amigo2
FROM amigo
INNER JOIN aluno a1 ON amigo.idt_aluno1 = a1.idt_aluno
INNER JOIN aluno a2 ON amigo.idt_aluno2 = a2.idt_aluno;

-- Consultar alunos e seus amigos usando LEFT JOIN
SELECT 
    aluno.des_nome AS nome_aluno,
    amigo.idt_aluno2 AS amigo_id,
    a2.des_nome AS nome_amigo
FROM aluno
LEFT JOIN amigo ON aluno.idt_aluno = amigo.idt_aluno1
LEFT JOIN aluno a2 ON amigo.idt_aluno2 = a2.idt_aluno;

-- Consultar alunos que foram mencionados como amigos usando RIGHT JOIN
SELECT 
    a2.des_nome AS nome_amigo,
    amigo.idt_aluno1 AS amigo_de_id,
    a1.des_nome AS amigo_de_nome
FROM amigo
RIGHT JOIN aluno a2 ON amigo.idt_aluno2 = a2.idt_aluno
LEFT JOIN aluno a1 ON amigo.idt_aluno1 = a1.idt_aluno;
