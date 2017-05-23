class Article < ApplicationRecord
   belongs_to :cn_info

   def read_pdf(url)
     content_ary = []
     io = open(url)
     IO.copy_stream(io,  "/home/roccia/pdf_data/#{Time.now}_#{io.base_uri.to_s.split('/')[-1]}")
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
