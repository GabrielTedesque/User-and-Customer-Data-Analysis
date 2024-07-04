# Medidas DAX Explicadas

Aqui estão as explicações detalhadas para cada uma das medidas DAX utilizadas no projeto de análise de dados de usuários e clientes.



 **01 - Qtde Client**

DISTINCTCOUNT(dClient[id])

Descrição: Conta o número distinto de clientes na tabela dClient com base no campo id.

**02 - Qtd City**


DISTINCTCOUNT(dAddress[city])

Descrição: Conta o número distinto de cidades na tabela dAddress com base no campo city.

**03 - Qtd State**


DISTINCTCOUNT(dAddress[state])

Descrição: Conta o número distinto de estados na tabela dAddress com base no campo state.

**04 - Qtde Client ATV**


CALCULATE(
    DISTINCTCOUNT(dClient[id]),
    fPayment[status] = "Active"
)

Descrição: Conta o número de clientes distintos que têm o status de pagamento "Active" na tabela fPayment.

**05 - Qtde Client BLC**

Copiar código
CALCULATE(
    DISTINCTCOUNT(dClient[id]),
    fPayment[status] = "Blocked"
)

Descrição: Conta o número de clientes distintos que têm o status de pagamento "Blocked" na tabela fPayment.

**06 - Perc Client ATV**

DIVIDE(
    CALCULATE(
        DISTINCTCOUNT(dClient[id]),
        fPayment[status] = "Active"
    ),
    DISTINCTCOUNT(dClient[id])
)

Descrição: Calcula a porcentagem de clientes com status "Active" em relação ao total de clientes.

**07 - City quantity**

DISTINCTCOUNT(dAddress[city])

Descrição: Conta o número distinto de cidades na tabela dAddress com base no campo city.

**08 - Average Age of Users**

VAR Birth =
    SUMMARIZE(
        dClient,
        dClient[id],
        "Age",
        DATEDIFF(
            MAX(dClient[date_of_birth]),
            TODAY(),
            YEAR
        )
    )

RETURN
    AVERAGEX(Birth, [Age])

Descrição: Calcula a idade média dos usuários com base na data de nascimento registrada na tabela dClient.

**09 - Perc Client BLC**

DIVIDE(
    CALCULATE(
        DISTINCTCOUNT(dClient[id]),
        fPayment[status] = "Blocked"
    ),
    DISTINCTCOUNT(dClient[id])
)

Descrição: Calcula a porcentagem de clientes com status "Blocked" em relação ao total de clientes.

**10 - Perc Client Idle**

DIVIDE(
    CALCULATE(
        DISTINCTCOUNT(dClient[id]),
        fPayment[status] = "Idle"
    ),
    DISTINCTCOUNT(dClient[id])
)

Descrição: Calcula a porcentagem de clientes com status "Idle" em relação ao total de clientes

**11 - Perc Client Pending**

DIVIDE(
    CALCULATE(
        DISTINCTCOUNT(dClient[id]),
        fPayment[status] = "Pending"
    ),
    DISTINCTCOUNT(dClient[id])
)

Descrição: Calcula a porcentagem de clientes com status "Pending" em relação ao total de clientes.
