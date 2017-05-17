class Article < ApplicationRecord
   belongs_to :cn_info

   def self.read_pdf(url)
    content_ary = []
    io = open(url)
    begin
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        content = page.text
        content_ary << content
      end
    rescue PDF::Reader::MalformedPDFError =>err
      Rails.logger.info "#############{err.response}############"
    end
    self.update(:content => content_ary)
  end

end
