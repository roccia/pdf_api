require 'json'
require 'open-uri'
require 'zlib'
require 'base64'


class CnInfo < ActiveRecord::Base
  validates_uniqueness_of :url

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
      res =  query(p)
      if res[:status] == 'success'
        {:status => 'success',:msg => res[:info]}
      else
        {:status => 'fail'}
      end
    else
      pages = (page_num/50.to_f).round
      res = query(pages)
      if  res[:status] == 'success'
       {:status => 'success', :msg => res[:info]}
      else
        {:status => 'fail'}
      end
    end

  end

  def get_page_num
    response = RestClient.post(URL, @params)
    res = JSON.parse response.body
    page_num = res["totalAnnouncement"]
    page_num
  end


  def query(page_num)
    ary = []
    final_result = ''
    @params.merge!(pageNUm:page_num)
      begin
        response = RestClient.post(URL, @params)
        rs = JSON.parse response
        Rails.logger.info "Response ###############  #{rs}"
        if rs.present?
          rs["announcements"].each do |s|
            announcementTitle = s["announcementTitle"]
            commpany_code = s["secCode"]
            commpany_name = s["secName"]
            adjunctUrl = s["adjunctUrl"]
            time = s["announcementTime"]
            unless announcementTitle.include?("摘要")
              content = read_pdf("#{URL_PERFIX}/#{adjunctUrl}")
              ary << {:industry => @params['trade'],
                      :plate => @params['plate'],
                      :category => @params['category'],
                      :title => announcementTitle,
                      :report_date => Time.at(time/1000),
                      :code => commpany_code,
                      :name => commpany_name,
                      :url => "#{URL_PERFIX}/#{adjunctUrl}",
                      :content => content
              }
            end
          end

          final_result = {:status => 'success' , :info => ary.uniq}
        else
          final_result = {:status => 'fail'}
        end
      rescue RestClient::ExceptionWithResponse => err
        Rails.logger.info "#############{err.response}############"
      end
    final_result
  end


  def read_pdf(url)
    content_ary = []
    io = open(url)
    reader = PDF::Reader.new(io)
    reader.pages.each do |page|
      content =page.text
      content_ary << content
    end
    content_ary
  end

  def save_to_db(res)
    res.each do |s|
   if check_db(s[:url]).blank?
      self.industry = s[:industry]
      self.category = s[:category]
      self.plate = s[:plate]
      self.title = s[:title]
      self.company_code = s[:code]
      self.company_name = s[:name]
      self.url = s[:url]
      self.context = s[:content]
      self.report_date = s[:report_date]
      self.save
   else
      {:status => 'exist'}
     end
    end
  end

  def check_db(url)
    CnInfo.where(:url => url)
  end

end


