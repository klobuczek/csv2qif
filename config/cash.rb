{
  :type => 'Cash',
  :header => 1,
  :date => lambda{ c },
  :amount => lambda{ -d.to_f },
  #:where => lambda{ e == 'USD' },
  :payee => lambda{ b },
  :category => lambda{ a },
  :mappings => ["/^/Expenses:2008:/"]
}
