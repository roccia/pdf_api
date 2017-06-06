require 'open-uri'
class Article < ApplicationRecord
  belongs_to :cn_info

  def read_pdf(url)
    content_ary = []
    io = open(url)
    begin
      reader = PDF::Reader.new(io)
    rescue PDF::Reader::MalformedPDFError => err
      self.content = err
    else
      reader.pages.each do |page|
        content_ary << page.text
      end
      self.content = content_ary
    ensure
      self.save
    end

  end

end
