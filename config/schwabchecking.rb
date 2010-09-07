{
        :type => 'Bank',
        :header => 4,
        :date => lambda { a },
        :payee => lambda { d },
        :amount => lambda { e ? -e.to_f : f },
        :category => lambda { "Assets:SchwabOne" if  d =~ /Overdraft Transfer from Brokerage -1865/ }
}