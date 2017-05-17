require 'json'
require 'open-uri'
require 'zlib'
require 'base64'


class CnInfo < ActiveRecord::Base
  has_many :articles
  URL = "http://www.cninfo.com.cn/cninfo-new/announcement/query"
  URL_PERFIX = "http://www.cninfo.com.cn"


  def get_result(option={})
    @params = {
        stock: option[:stock],
        searchkey: '',
        plate: option[:plate],
        category: option[:category],
        trade: option[:industry],
        column: 'szse_main',
        columnTitle: '历史公告查询',
        pageSize: 50,
        tabName: 'fulltext',
        seDate: "#{option[:start_time]} ~ #{option[:end_time]}"
    }
    page_num = get_page_num
    return  {:status => 0,:msg => '无数据'} if page_num == 0
    if page_num < 50
      res =  query_pdf(p)
      if res[:status] ==  0
        {:status => 'exist'}
      elsif res[:status] == 1
        {:status => 'success' }
      else
        {:status => 'fail'}
      end
    else
      pages = (page_num/50.to_f).round
      res = query_pdf(pages)
      if res[:status] ==  0
        {:status => 'exist'}
      elsif res[:status] == 1
        {:status => 'success' }
      else
        {:status => 'fail'}
      end
    end

  end

  def self.get_page_num
    response = RestClient.post(URL, @params)
    res = JSON.parse response.body
    page_num = res["totalAnnouncement"]
    page_num
  end

  def self.query_pdf(page_num)
    ary = []
    final_result = ''
    @params.merge!(pageNUm:page_num)
      begin
        response = RestClient.post(URL, @params)
        rs = JSON.parse response
        self.context = rs
        self.stock_num = @params['stock']
        self.save
        Rails.logger.info "Response ###############  #{rs}"
        if rs.present?
          last_url = rs["announcements"].last["adjunctUrl"]
          if  Article.where(:url => "#{URL_PERFIX}/#{last_url}").exists?
            final_result = {:status => 0}
          else
            rs["announcements"].each do |s|
              announcementTitle = s["announcementTitle"]
              commpany_code = s["secCode"]
              commpany_name = s["secName"]
              adjunctUrl = s["adjunctUrl"]
              time = s["announcementTime"]
              unless announcementTitle.include?("摘要")
                ary << {:industry => @params['trade'],
                        :plate => @params['plate'],
                        :category => @params['category'],
                        :title => announcementTitle,
                        :report_date => Time.at(time/1000),
                        :company_code => commpany_code,
                        :company_name => commpany_name,
                        :url => "#{URL_PERFIX}/#{adjunctUrl}",
                }
              end
            end
            self.articles.create!(ary.uniq)
            final_result = {:status => 1}
            ArticleJob.perform_later(self.id)
          end
        else
          final_result = {:status => -1 }
        end
      rescue RestClient::ExceptionWithResponse => err
        Rails.logger.info "#############{err.response}############"
      end
    final_result
  end

end


