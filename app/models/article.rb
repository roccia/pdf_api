require 'open-uri'
class Article < ApplicationRecord
  belongs_to :cn_info

  def read_pdf(url)
    content_ary = []
    io = open(url)
    begin
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        content_ary << page.text
      end
       self.content = content_ary
    rescue PDF::Reader::MalformedPDFError => err
        self.error_info = "文件不可读取#{err}"
    end
  ensure
    self.save
  end

end
