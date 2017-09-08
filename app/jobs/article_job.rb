# class ArticleJob < ActiveJob::Base
#   queue_as :default
#
#   def perform(id)
#      articles = Article.where(:cn_info_id => id)
#      articles.each do |a|
#        a.read_pdf(a.url)
#      end
#   end
# end
