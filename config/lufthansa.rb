{
        :field_separator =>  ';',
        :type => 'CCard',
        :header => 3,
        :date => lambda { Date.parse(d) },
        :payee => lambda { f },
        :amount =>  lambda { n=='H' ? m : -m.to_f },
        :num => lambda { a },
        :address => lambda { g },
        :memo => lambda { [h,i].join '\n' }
}