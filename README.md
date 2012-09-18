# Csv2qif

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'csv2qif'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv2qif

## Usage

cvs2qif -- format converter

Usage: csv2qif [options] [file...]

The csv2qif utility reads the specified csv files, or the standard input if no files are specified,
converting the input to qif format. The output is written to either the standart output if read from
standard input or file with the same base name as input and qif extension or to a file specified as an
option.

The CONDITION and COLUMN below are in the simplest case represented by just one lower case letter (a-z) indicating the the csv column
which should be mapped to a particular line in a qif record. As a minimum a date and amount column should be mapped
e.g.
#> csv2qif -D a --amount b file.csv
will assume the first column (a) in the csv file is date and  second (b) the amount. Those are as well defaults.
CONDITION and COLUMNS may as well be any ruby expression. In this case the expression will be evaluated in a context
in which the column names (a-z) are available as methods returning the value in the corresponding column or nil if empty.

Options are:

    -b, --bundle BUNDLE              Name of an option bundle
                                     Default: default
    -t, --type Type                  Type of acoount: CCard, Bank or Cash
                                     Default: CCard
    -w, --where CONDITION            only records satisfying CONDITION will be converted
    -s, --field_separator SEPARATOR  field seprator. Default: ,
    -m, --mappings MAPPINGS          comma separated list of mappings in the format: /pattern/replacement/
                                     Use for modifying categories
    -d, --header N                   number of rows occupied by headers before actual data
    -f, --date_format Format         date format in the csv file
    -h, --help                       Show this help message.

QIF Record options:
    -D, --date COLUMN                Date
    -T, --amount COLUMN              Amount
    -C, --cleared COLUMN             Cleared Status
    -N, --num COLUMN                 Num (check or reference number)
    -P, --payee COLUMN               Payee
    -M, --memo COLUMN                Memo
    -A, --address COLUMN             Address (up to five lines; the sixth line is an optional message)
    -L, --category COLUMN            Category (Category/Subcategory/Transfer/Class)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
