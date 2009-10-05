class QIF
  COLUMNS = ('a'..'z').to_a
  QIF_CODES = [
          [:date, :D],
          [:payee, :P],
          [:category, :L],
          [:amount, :T],
          [:memo, :M],
          [:num, :N],
          [:address, :A]
  ]

  def initialize stream, options
    @stream = stream
    @options = options
    #options.keys.each { |m| undef_method m }
    stream.puts"!Type:#{options[:type]}"
  end

  def header row

  end

  def push row
    @row = row
    return unless @options[:where].nil? or eval @options[:where]
    QIF_CODES.each do |key, code|
      @current_key = key
      next unless value = (eval @options[key] if @options.key? key)
      case key
        when :address then
          put_lines code, value, 5
        when :category then
          @options[:mappings].each {|pattern, replacement| value.gsub!(pattern, replacement) } if @options[:mappings]
          put_line code, value
        else
          put_line code, value
      end
    end
    @stream.puts '^'
  end

  def method_missing(sym, *args, &block)
    return unless value=@row[COLUMNS.index(sym.to_s)]
    case @current_key
      when :date: Date.parse(value).strftime("%m/%d/%Y")
      when :amount: QIF.parse_float value
      else value.strip
    end
  end

  private

  def self.parse_float n
    if i=n.index(',')
      n.gsub!(/,/, i + 3 < n.length ? '': '.')
    end
    n.gsub(/\$/,'').to_f
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
    return if (value = value.to_s.gsub(/\s+/, ' ').strip).empty?
    @stream.puts code.to_s + value
  end
end  
  