class Article < ApplicationRecord
   belongs_to :cn_info

   def read_pdf(url)
     content_ary = []
     io =  Net::HTTP.get_response(URI.parse(url ))

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
