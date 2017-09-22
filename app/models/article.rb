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
    rescue PDF::Reader::MalformedPDFError, PDF::Reader::EncryptedPDFError,
        PDF::Reader::InvalidObjectError, PDF::Reader::UnsupportedFeatureError => err

      self.error_info = "文件不可读取#{err}"
    end
  ensure
    self.save
  end

  def run
    Article.where.not(url: nil).where(content: nil).first(100).each do |a|
      begin
        a.read_pdf(a.url)
      rescue PDF::Reader::MalformedPDFError, PDF::Reader::EncryptedPDFError,
          PDF::Reader::InvalidObjectError, PDF::Reader::UnsupportedFeatureError => err
        a.error_info = err
      ensure
        a.save
      end

    end
  end

end

