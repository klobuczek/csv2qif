class QIF
  COLUMNS = ('a'..'z').to_a
  QIF_CODES = [
          [:date, :D],
          [:amount, :T],
          [:cleared, :C, 'Cleared Status'],
          [:num, :N, 'Num (check or reference number)'],
          [:payee, :P],
          [:memo, :M],
          [:address, :A, 'Address (up to five lines; the sixth line is an optional message)'],
          [:category, :L, 'Category (Category/Subcategory/Transfer/Class)']
  ]

  def reset stream, options
    @stream = stream
    @options = options
    #options.keys.each { |m| undef_method m }
    stream.puts"!Type:#{options[:type]}"
  end

  def block
    Proc.new {}
  end

  def header row

  end

  def push row
    @row = row
    return unless @options[:where].nil? or call_or_eval(:where)
    QIF_CODES.each do |key, code|
      next unless value = call_or_eval(key)
      case key
        when :date then
          put_line code, (value.instance_of?(Date) ? value : Date.parse(value, true)).strftime("%m/%d/%Y")
        when :amount then
          put_line code, sprintf("%.2f", value.to_f)
        when :address then
          put_lines code, value, 5
        when :category then
          @options[:mappings].each {|condition, pattern, replacement| value.gsub!(pattern, replacement) if call_or_eval_or_value condition} if @options[:mappings]
          put_line code, value
        else
          put_line code, value
      end
    end
    @stream.puts '^'
  end

  def method_missing(sym, *args, &block)
    @row[COLUMNS.index(sym.to_s)]
  end

  private

  def call_or_eval key
    if instr = @options[key]
      call_or_eval_or_value instr
    end
  end

  def call_or_eval_or_value value
    value.instance_of?(Proc) ? value.call : value.instance_of?(String) ? eval(value) : value
  end

  def put_lines code, value, limit
    overflow = []
    value.each_line do |line|
      unless (line = line.strip).empty?
        if (limit -= 1) > 0
          put_line code, line
        else
          overflow << line
        end
      end
    end
    put_line code, overflow.join(' ') unless overflow.empty?
  end

  def put_line code, value
    return if (value = value.to_s.gsub(/\n+/, ' ').strip).empty?
    @stream.puts code.to_s + value
  end
end  
  