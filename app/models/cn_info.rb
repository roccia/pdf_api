require 'json'
require 'open-uri'
require 'zlib'
require 'base64'


class CnInfo < ActiveRecord::Base
  validates_uniqueness_of :url

  URL = "http://www.cninfo.com.cn/cninfo-new/announcement/query"
  URL_PERFIX = "http://www.cninfo.com.cn"

  def initialize(option={})
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
  end


  def get_result

    page_num = get_page_num
    return  {:status => 0,:msg => '无数据'} if page_num == 0
    if page_num < 50
      res =  query(p)
      if res[:status] == 'success'
        {:status => 'success'}
      else
        {:status => 'fail'}
      end
    else
      pages = (page_num/50.to_f).round
      res = query(pages)
      if  res[:status] == 'success'
       {:status => 'success'}
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
              self.industry = @params['trade']
              self.category = @params['category']
              self.plate = @params['plate']
              self.title = announcementTitle
              self.company_code = commpany_code
              self.company_name = commpany_name
              self.url = "#{URL_PERFIX}/#{adjunctUrl}"
              self.context = content
              self.report_date = Time.at(time/1000)
              self.save
            end
          end

          final_result = {:status => 'success' }
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
    end
  end


end


