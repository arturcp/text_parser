module TextParser
  def parse(args = {})
    options = {
      :dictionary => nil,
      :order => :word,
      :order_direction => :asc,
      :negative_dictionary => nil
    }.merge(args)
    result = []
    text = process_text
    options[:dictionary] = text.split(" ") unless options[:dictionary]
    regex = Regexp.new(options[:dictionary].join("|"), Regexp::IGNORECASE)
    match_result = text.scan(regex).map{|i| i.downcase}
    match_result.each do |w|
      result << {:hits => match_result.count(w), :word => w} unless result.select{|r| r[:word] == w}.shift
    end 
    result = result.sort_by{|i| i[options[:order]]}
    result.reverse! if options[:order_direction] == :desc
    result
  end
  
  private
  
  def process_text
    self.gsub(/[^\w\s\-]/, "")
  end
end