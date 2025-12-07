# universidade-star_schema-sql
Repositório: Criando um Star Schema para cenários de Universidade, como foco em Professor.

# Modelagem Dimensional – Universidade  
### Foco da Análise: Professor

Este repositório apresenta o desenvolvimento de um **modelo dimensional (Star Schema)** construído a partir de um banco de dados relacional de uma **Universidade**.  
O objetivo central é permitir análises relacionadas aos **professores**, seus departamentos, disciplinas, cursos e datas de oferta.

---

## Objetivo do Projeto

Desenvolver um **Data Warehouse** simplificado, com foco na criação de:

- **Tabela Fato** relacionada à oferta de disciplinas pelos professores  
- **Tabelas Dimensão** descrevendo professor, disciplina, curso, departamento e tempo  
- **Modelo Estrela (Star Schema)** completo e documentado  
- **Scripts em MySQL** para criação das tabelas dimensionais e fato  

Este projeto simula um ambiente de BI onde os gestores podem analisar:

- Quais disciplinas cada professor oferta  
- Em quais cursos ele atua  
- Distribuição de professores por departamento  
- Evolução temporal das ofertas  

---

## Modelo Relacional de Origem

O modelo original operacional da Universidade contém as seguintes entidades principais:

- Professor ( id_professor, id_departamento )
- Departamento ( id_departamento, nome, campus, id_professor )
- Curso ( id_curso, id_departamento ) 
- Disciplina ( id_disciplina, id_professor )
- DisciplinaCurso ( id_disciplina, id_curso ) 
- Aluno ( id_aluno )
- Matriculado ( id_aluno, id_disciplina )
- PreRequisitoDisciplina ( id_disciplina, id_prerequisito )
- PreRequisito ( id_prerequisito )

---

## Star Schema – Visão Geral

A granularidade definida foi:

Uma linha de fato por:
Professor × Disciplina × Curso x Departamento x Data

### Dimensões criadas:

- DIM_PROFESSOR – dados dos professores  
- DIM_DEPARTAMENTO – informações dos departamentos  
- DIM_DISCIPLINA – infromações das disciplinas  
- DIM_CURSO – dados dos cursos oferecidos  
- DIM_DATA – dimensão de tempo/calendário

### Tabela Fato criada:

- FATO_PROFESSOR - Tabela fato com métricas sobre atividades dos professores. Relaciona professor, disciplina, curso e datas.
  
---

## Diagrama Lógico – Star Schema
                        FATO_PROFESSOR
                             |
       |----------|----------|----------|----------|
      DIM_       DIM_       DIM_       DIM_       DIM_
    PROFESSOR   CURSO    DISCIPLINA    DATA    DEPARTAMENTO
---

## Scripts MySQL

Os scripts para criação das tabelas do Data Warehouse estão localizados em:
/sql/professor_star_schema.sql

Eles contêm:

- Criação das tabelas dimensão  
- Criação da tabela fato  
- Definição de chaves primárias  
- Criação de relacionamentos (FKs)

---
##  Dimensão DATA

Foi criada manualmente e inclui:

- Data completa  
- Ano  
- Semestre  
- Trimestre  
- Mês
- Nome do mês  
- Dia da semana  
- Feriado
- Periodo acadêmico  

## Dimensão CURSO

Tem como origem da tabela Curso. Inclui:

- nome_curso
- tipo_curso
- modalidade 
- carga_horaria_total
- data_criacao

## Dimensão DISCIPLINA

Tem como origem da tabela Disciplina. Inclui:

- nome_disciplina
- codigo_disciplina
- carga_horaria
- creditos
- tipo_disciplina
- nivel
- possui_prerequisito
- data_criacao

## Dimensão DEPARTAMENTO

Tem como origem da tabela Departamento. Inclui:

- nome_departamento
- campus
- sigla 
- data_criacao

## Dimensão PROFESSOR

Tem como origem da tabela Professor. Inclui:

- nome_professor
- titulacao
- ano_ingresso
- status
- data_criacao

## TABELA FATO_PROFESSOR

### Chave Primária:

- id_fato (PK – AUTO_INCREMENT)

### Chaves Estrangeiras:

- id_professor → DIM_PROFESSOR
- id_departamento → DIM_DEPARTAMENTO
- id_curso → DIM_CURSO
- id_disciplina → DIM_DISCIPLINA
- id_data → DIM_DATA

### Atributos de Medida:

- qtd_deisciplinas_ministradas
- qtd_cursos_envolvidos
- qtd_prerequisitos_ministrados
- indicador_coordenador

## Análises

- Carga horária por Professor
- Professores por Departamento
- Evolução temporal das atividades
- Ranking de Professores por carga horário
- Professores multidisciplinares
- Análise de Pré-Requisitos por Professor
- Comparativo entre Departamentos
- Distribuição por Campus

---


