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
      self.content = err
    ensure
      self.save
    end

  end

end
