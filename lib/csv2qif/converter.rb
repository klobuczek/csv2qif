require 'csv'

module Csv2qif
  class Converter
    def initialize file
      @file = file
    end

    def reader rs=nil
      @reader ||= CSV.open(@file, "r", rs)
    end

    def type type
      puts "!Type:#{type}"
    end

    def datum value
      puts "D" + value
    end

    def payee value
      puts "P" + value
    end

    def category value
      puts "L" + value
    end

    def amount value
      puts "T#{value}"
    end

    def memo value
      puts "M" + value
    end

    def num value
      puts "N" + value
    end

    def address value
      puts "A" + value
    end

    def ende
      puts "^"
    end

    def amex2008 privat=false
      7.times {reader.shift}
      type "CCard"
      reader.each do |row|
        if row[4]
          datum row[0]
          payee row[2]
          category "Expenses:#{'Private:' if privat}"+row[12].gsub('-', ':') if row[12]
          amount row[5]
          num row[11]
          [9, 10].each {|i| row[i].split(/$/).each_with_index {|l, i| address(l.strip) unless l.strip.empty? or i > 3 } if row[i]}
          ende
        end
      end
    end

    def process type
      case type
        when "amex2008" then
          amex2008
        when "amexblue2008" then
          amex2008 true
        when "amex" then
          reader.shift
          type "CCard"
          reader.each do |row|
            if row[4]
              datum row[4]
              payee row[6]
              category "Expenses:"+row[0]+":"+row[3]
              amount -row[7].to_f if row[7]
              amount row[8] if row[8]
              ende
            end
          end
        when "amexblue" then
          reader.shift
          type "CCard"
          reader.each do |row|
            if row[4]
              puts "D"+row[4]
              puts "P"+row[6]
              puts "LExpenses:Private:"+row[0]+":"+row[3]
              puts "T-"+row[7] if row[7]
              puts "T"+row[8] if row[8]
              puts "^"
            end
          end
        when "icheck" then
          type "Bank"
          reader.each do |row|
            datum row[0]
            memo row[1]
            num row[1]+row[2] unless row[2].empty?
            payee row[3]
            category "Assets:SchwabOne" if row[1] =="TRANSFER"
            category "Assets:Cash" if row[1] =="ATM"
            amount -row[4].to_f unless row[4].empty?
            amount row[5] unless row[5].empty?
            ende
          end
        when "schwabone" then
          reader.shift
          reader.shift
          puts "!Type:Bank"
          reader.each do |row|
            if row[3]!='SWMXX' && row[4] !="FOR INV CKG OVERDRAFT   4400-01213567 type: IC OVERDRAFT TRF"
              puts "D"+row[0]
              puts "P"+row[4]
              puts "T"+row[6]
              puts "^"
            end
          end
        when "lufthansa" then
          reader(";").shift
          reader.shift
          puts "!Type:CCard"
          reader.each do |row|
            puts "D"+row[3]
            puts "P"+ row[5, row[7]=='EUR'?2:4].join(' ')
            puts "T-"+row[12] if row[13]=='S'
            puts "T"+row[12] if row[13]=='H'
            puts "^"
          end
        when "cash" then
          puts "!Type:Cash"
          reader.each do |row|
            puts "D"+row[2]
            puts "P"+row[1]
            puts "LExpenses:"+row[0] if row[0]
            puts "T-"+row[3]
            puts "^"
          end
      end
    end
  end
end