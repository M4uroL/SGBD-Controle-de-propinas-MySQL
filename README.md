# Controle de Propinas - Sistema de Gestão Acadêmica (MySQL)

Este projeto implementa um banco de dados completo para controle de propinas (mensalidades) de uma instituição de ensino. Ele permite gerenciar **alunos**, **cursos**, **funcionários**, **propinas** e **pagamentos**, além de fornecer **funções**, **procedures**, **triggers** e **relatórios SQL úteis**.

---

##  Objetivos 

Fornecer uma base sólida e prática para a gestão financeira de propinas e controle acadêmico em uma instituição de ensino. Este sistema foi projetado para:

- Cadastrar cursos, alunos e funcionários;
- Registrar propinas mensais dos alunos;
- Registrar pagamentos realizados por funcionários;
- Gerar relatórios e consultas analíticas para facilitar decisões.

---

## Estrutura do Projeto

### 🗃Tabelas Criadas:

| Tabela        | Descrição                                        |
|---------------|--------------------------------------------------|
| `curso`       | Cadastro de cursos oferecidos                    |
| `aluno`       | Informações pessoais e curso associado do aluno  |
| `funcionario` | Dados dos funcionários que processam pagamentos |
| `propina`     | Mensalidades dos alunos, com status de pagamento |
| `pagamento`   | Registros de pagamentos realizados               |

---

### ⚙️ Funcionalidades Adicionais

- `Function` `calcular_total_pagamentos_aluno`: retorna o total pago por um aluno.
- `Procedure` `registrar_pagamento`: insere um pagamento e atualiza o status da propina.
- `Trigger` `trg_atualizar_status_propina`: atualiza automaticamente o status da propina após pagamento.

---

## Como Usar

1. **Executar todo o script SQL** em um servidor MySQL (por exemplo, no MySQL Workbench).
2. O script cria o banco `controle_propinas`, estrutura as tabelas e insere dados iniciais (mock data).
3. Realize suas consultas, adicione novos dados ou integre com aplicações externas.

---

## Consultas e Relatórios Úteis

Algumas consultas implementadas no projeto:

- Alunos devedores (`status = 'Pendente' ou 'Atrasado'`)
-  Total de alunos por curso
-  Alunos que já pagaram alguma propina
-  Pagamentos por funcionário
-  Valor total arrecadado por funcionário
-  Total de propinas por status
-  Cursos com mais alunos devedores
- Lista de alunos sem dívidas (com função de total pago)

---

## Exemplos de Consultas

```sql
-- Lista de alunos devedores
SELECT a.nome, c.nome_curso, p.mes, p.status
FROM aluno a
JOIN propina p ON a.id_aluno = p.id_aluno
JOIN curso c ON a.cod_curso = c.cod_curso
WHERE p.status IN ('Pendente', 'Atrasado');

-- Valor total arrecadado por funcionário
SELECT f.nome, SUM(pg.valor_pago) AS total_arrecadado
FROM funcionario f
JOIN pagamento pg ON f.id_funcionario = pg.id_funcionario
GROUP BY f.id_funcionario;
