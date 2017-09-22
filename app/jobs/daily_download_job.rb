class DailyDownloadJob < ActiveJob::Base
  queue_as :default

  def perform
    articles = Article.where(created_at: 1.day.ago..Date.today,content:nil)
    articles.each do |a|
      a.read_pdf(a.url)
    end
  end


end
