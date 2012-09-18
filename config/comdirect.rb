{
    :field_separator => ';',
    :type => 'Bank',
    :header => 23,
    :date => lambda { a },
    :amount => lambda { e.to_f },
    :payee => lambda { d }
}
