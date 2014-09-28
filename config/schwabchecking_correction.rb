{
        :type => 'Bank',
        :header => 4,
        :date_format => '%m/%d/%Y',
        :date => lambda { a },
        :payee => lambda { d },
        :amount => lambda { e && !e.empty? ? -e.to_f : f },
        :category => lambda { "Assets:SchwabOne" if  d =~ /Overdraft Transfer from Brokerage -1865/ },
        :where => lambda {!(e.nil? || e.empty?) && !(d =~ /Overdraft Transfer from Brokerage -1865/) }
}
