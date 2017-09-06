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
       update(content:content_ary)
    rescue PDF::Reader::MalformedPDFError => err
        update(content:"文件不可读取#{err}")
    end

  end

end
