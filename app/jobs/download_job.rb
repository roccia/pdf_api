class DownloadJob < ActiveJob::Base

  def perform(id)
    article = Article.find id
    article.read_pdf(article.url)
  end

end