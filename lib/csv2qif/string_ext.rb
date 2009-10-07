class String
  alias super_to_f to_f

  def to_f
    if i=index(',')
      gsub!(/,/, i + 3 < length ? '': '.')
    end
    gsub(/\$/, '').super_to_f
  end
end