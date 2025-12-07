-- Desafio: Criando um Star_Schema para cenários de vendas
-- com power BI.
-- Autor: Roddy R. G.

-- EXEMPLOS DE ANÁLISES 

-- I. Carga Horária por Professor:
SELECT p.nome_professor, 
       SUM(d.carga_horaria) as carga_total,
       COUNT(*) as total_disciplinas
FROM fato_professor f
JOIN dim_professor p ON f.id_professor = p.id_professor
JOIN dim_disciplina d ON f.id_disciplina = d.id_disciplina
GROUP BY p.nome_professor
ORDER BY carga_total DESC;

-- II. Professores por Departamento:
SELECT d.nome_departamento,
       COUNT(DISTINCT f.id_professor) as total_professores,
       AVG(f.qtd_disciplinas_ministradas) as media_disciplinas
FROM fato_professor f
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
GROUP BY d.nome_departamento;

-- III. Evolução Temporal das Atividades:
SELECT dt.ano,
       dt.semestre,
       COUNT(DISTINCT f.id_professor) as professores_ativos,
       COUNT(DISTINCT f.id_disciplina) as disciplinas_oferecidas,
       SUM(f.qtd_prerequisitos_ministrados) as total_prerequisitos
FROM fato_professor f
JOIN dim_data dt ON f.id_data = dt.id_data
GROUP BY dt.ano, dt.semestre
ORDER BY dt.ano DESC, dt.semestre DESC;

-- IV. Ranking de Professores por Carga Horária:
SELECT 
    p.nome_professor,
    d.nome_departamento,
    COUNT(DISTINCT f.id_disciplina) as total_disciplinas,
    SUM(disc.carga_horaria) as carga_horaria_total,
    ROUND(AVG(disc.carga_horaria), 2) as media_horas_disciplina,
    CASE 
        WHEN SUM(disc.carga_horaria) > 200 THEN 'Alta Carga'
        WHEN SUM(disc.carga_horaria) BETWEEN 100 AND 200 THEN 'Média Carga'
        ELSE 'Baixa Carga'
    END as classificacao_carga
FROM fato_professor f
JOIN dim_professor p ON f.id_professor = p.id_professor
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
JOIN dim_disciplina disc ON f.id_disciplina = disc.id_disciplina
WHERE p.status = 'Ativo'
GROUP BY p.id_professor, p.nome_professor, d.nome_departamento
ORDER BY carga_horaria_total DESC
LIMIT 10;

-- V. Professores Multidisciplinares:
SELECT 
    p.nome_professor,
    COUNT(DISTINCT f.id_curso) as cursos_envolvidos,
    COUNT(DISTINCT f.id_disciplina) as disciplinas_distintas,
    GROUP_CONCAT(DISTINCT c.nome_curso ORDER BY c.nome_curso SEPARATOR '; ') as lista_cursos,
    GROUP_CONCAT(DISTINCT d.nome_departamento SEPARATOR '; ') as departamentos
FROM fato_professor f
JOIN dim_professor p ON f.id_professor = p.id_professor
JOIN dim_curso c ON f.id_curso = c.id_curso
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
GROUP BY p.id_professor, p.nome_professor
HAVING COUNT(DISTINCT f.id_curso) >= 3
ORDER BY cursos_envolvidos DESC;

-- VI. Análise de Pré-Requisitos por Professor:
SELECT 
    p.nome_professor,
    d.nome_departamento,
    SUM(f.qtd_prerequisitos_ministrados) as total_prerequisitos,
    COUNT(DISTINCT CASE 
        WHEN disc.possui_prerequisito = TRUE THEN f.id_disciplina 
    END) as disciplinas_com_prerequisito,
    ROUND(
        SUM(f.qtd_prerequisitos_ministrados) * 100.0 / 
        NULLIF(COUNT(DISTINCT f.id_disciplina), 0), 
        2
    ) as percentual_prerequisitos
FROM fato_professor f
JOIN dim_professor p ON f.id_professor = p.id_professor
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
JOIN dim_disciplina disc ON f.id_disciplina = disc.id_disciplina
GROUP BY p.id_professor, p.nome_professor, d.nome_departamento
HAVING total_prerequisitos > 0
ORDER BY total_prerequisitos DESC;

-- VII. Comparativo entre Departamentos:
SELECT 
    d.nome_departamento,
    d.campus,
    COUNT(DISTINCT f.id_professor) as total_professores,
    COUNT(DISTINCT f.id_curso) as total_cursos,
    COUNT(DISTINCT f.id_disciplina) as total_disciplinas,
    SUM(f.qtd_disciplinas_ministradas) as disciplinas_ministradas_total,
    SUM(CASE 
        WHEN f.indicador_coordenador = TRUE THEN 1 
        ELSE 0 
    END) as professores_coordenadores,
    ROUND(
        COUNT(DISTINCT f.id_professor) * 100.0 / 
        (SELECT COUNT(DISTINCT id_professor) FROM fato_professor), 
        2
    ) as percentual_universidade
FROM fato_professor f
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nome_departamento, d.campus
ORDER BY total_professores DESC;

-- VIII. Distribuição por Campus:
SELECT 
    d.campus,
    COUNT(DISTINCT f.id_professor) as professores,
    COUNT(DISTINCT d2.id_departamento) as departamentos,
    COUNT(DISTINCT f.id_curso) as cursos,
    ROUND(AVG(disc.carga_horaria), 2) as media_carga_horaria,
    SUM(f.qtd_prerequisitos_ministrados) as total_prerequisitos,
    ROUND(
        COUNT(DISTINCT f.id_professor) * 100.0 / 
        SUM(COUNT(DISTINCT f.id_professor)) OVER(), 
        2
    ) as percentual_professores
FROM fato_professor f
JOIN dim_departamento d ON f.id_departamento = d.id_departamento
JOIN dim_disciplina disc ON f.id_disciplina = disc.id_disciplina
JOIN dim_departamento d2 ON f.id_departamento = d2.id_departamento
GROUP BY d.campus
ORDER BY professores DESC;
