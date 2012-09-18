{
  :type => 'Cash',
  :header => 1,
  :date => lambda{ c },
  :amount => lambda{ -d.to_f },
  :payee => lambda{ b },
  :category => lambda{ a },
  :mappings => ["/^/Expenses:/"]
}
