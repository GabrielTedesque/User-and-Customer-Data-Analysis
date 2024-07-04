let
    // Definir a função para fazer a solicitação à API e obter os dados dos usuários
    get_users = (seed) =>
        let
            // Fazer a solicitação à API e obter os dados dos usuários
            response = Web.Contents("https://random-data-api.com/api/users/random_user?size=25&random_seed=" & Text.From(seed)),
            json = Json.Document(response)
        in
            json,

    // Utilizar List.Generate para repetir a solicitação até obter no máximo 150 registros
    users = List.Generate(
        // Função de inicialização
        () => get_users(1),
        // Condição de continuação
        each List.Count(_) < 150,
        // Função para obter o próximo valor
        each let
                seed = _{0}[id] + 1, // Incrementa o seed a partir do ID do primeiro usuário do conjunto
                new_users = get_users(seed),
                remaining_capacity = 150 - List.Count(_)
             in
                List.FirstN(new_users, remaining_capacity)
    ),

    // Converter a lista de listas em uma única lista de usuários
    all_users = List.Combine(users),
    #"Convertido para Tabela" = Table.FromList(all_users, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 Expandido" = Table.ExpandRecordColumn(#"Convertido para Tabela", "Column1", {"id", "uid", "password", "first_name", "last_name", "username", "email", "avatar", "gender", "phone_number", "social_insurance_number", "date_of_birth", "employment", "address", "credit_card", "subscription"}, {"id", "uid", "password", "first_name", "last_name", "username", "email", "avatar", "gender", "phone_number", "social_insurance_number", "date_of_birth", "employment", "address", "credit_card", "subscription"}),
    #"Limitado a 150 Linhas" = Table.FirstN(#"Column1 Expandido", 150),
    #"Duplicatas Removidas" = Table.Distinct(#"Limitado a 150 Linhas", {"id"}),
    #"Colunas Removidas" = Table.RemoveColumns(#"Duplicatas Removidas",{"uid", "password", "first_name", "last_name", "username", "email", "avatar", "gender", "phone_number", "social_insurance_number", "date_of_birth", "employment", "address"}),
    #"credit_card Expandido" = Table.ExpandRecordColumn(#"Colunas Removidas", "credit_card", {"cc_number"}, {"cc_number"}),
    #"subscription Expandido" = Table.ExpandRecordColumn(#"credit_card Expandido", "subscription", {"plan", "status", "payment_method", "term"}, {"plan", "status", "payment_method", "term"}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"subscription Expandido",{{"id", Int64.Type}}),
    #"Linhas em Branco Removidas" = Table.SelectRows(#"Tipo Alterado", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
    #"Linhas em Branco Removidas1" = Table.SelectRows(#"Linhas em Branco Removidas", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null})))
in
    #"Linhas em Branco Removidas1"
