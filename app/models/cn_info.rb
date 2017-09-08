require 'json'
require 'open-uri'
require 'zlib'
require 'base64'


class CnInfo < ActiveRecord::Base
  has_many :articles
  accepts_nested_attributes_for :articles
  serialize :context
  URL = "http://www.cninfo.com.cn/cninfo-new/announcement/query"
  URL_PERFIX = "http://www.cninfo.com.cn"


  def get_result(option={})
    if option[:start_time].blank? || option[:end_time].blank?
      return {:status => -2}
    end


    if option[:start_time] == option[:end_time]
      set_date = option[:start_time]
    else
      set_date = "#{option[:start_time]} ~ #{option[:end_time]}"
    end
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
        seDate: set_date
    }
    page_num = get_page_num
    return {:status => 0, :msg => '无数据'} if page_num == 0
    if page_num < 50
      res = query_pdf(p)
      if res[:status] == 0
        {:status => 'exist'}
      elsif res[:status] == 1
        {:status => 'success'}
      else
        {:status => 'fail'}
      end
    else
      pages = (page_num/50.to_f).round
      res = query_pdf(pages)
      if res[:status] == 0
        {:status => 'exist'}
      elsif res[:status] == 1
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
    Rails.logger.info '#######################'
    Rails.logger.info res["announcements"].size
    Rails.logger.info page_num
    page_num
  end

  def query_pdf(page_num)
    ary = []
    final_result = ''
    @params.merge!(pageNUm: page_num)
    begin
      response = RestClient.post(URL, @params)
      rs = JSON.parse response
      update(context: rs, stock_num: @params[:stock], page_num: page_num)

      Rails.logger.info "Response ###############  #{rs}"
      if rs.present?
        rs["announcements"].each do |s|
          announcementTitle = s["announcementTitle"]
          commpany_code = s["secCode"]
          commpany_name = s["secName"]
          adjunctUrl = s["adjunctUrl"]
          url = "#{URL_PERFIX}/#{adjunctUrl}"
          time = s["announcementTime"]
          unless announcementTitle.include?("摘要")
            attr = {industry: @params['trade'],
                    plate: @params['plate'],
                    category: @params['category'],
                    title: announcementTitle,
                    report_date: Time.at(time/1000),
                    company_code: commpany_code,
                    company_name: commpany_name,
                    url: url

            }
            p attr
            articles.where(url: url).first_or_create(attr)
          end
          final_result = {:status => 1}
        end
      else
        final_result = {:status => -1}
      end
    rescue RestClient::ExceptionWithResponse => err
      Rails.logger.info "#############{err.response}############"
    end
    final_result
  end


end


