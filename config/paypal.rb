{
    type: 'Bank',
    header: 1,
    date_format: '%m/%d/%Y',
    where: lambda { %w{Completed Refunded}.include? f },
    date: lambda { a },
    payee: lambda { [d, e, g].join ', ' },
    amount: lambda { h }
}