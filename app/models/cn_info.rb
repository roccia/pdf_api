require 'json'
require 'open-uri'
require 'zlib'
require 'base64'


class CnInfo < ActiveRecord::Base
  validates_uniqueness_of :url

  URL = "http://www.cninfo.com.cn/cninfo-new/announcement/query"
  URL_PERFIX = "http://www.cninfo.com.cn"
  INDUSTRY = {:农业 => "农、林、牧、渔业",
              :采矿业 => "采矿业",
              :制造业 => "制造业",
              :供应业 => "电力、热力、燃气及水生产和供应业",
              :建筑业 => "建筑业",
              :批发和零售业 => "批发和零售业",
              :交通运输 => "交通运输、仓储和邮政业",
              :住宿和餐饮业 => "住宿和餐饮业",
              :信息传输 => "信息传输、软件和信息技术服务业",
              :金融业 => "金融业",
              :房地产业 => "房地产业",
              :租赁和商务服务业 => "租赁和商务服务业",
              :科学研究和技术服务业 => "科学研究和技术服务业",
              :公共设施管理业 => "水利、环境和公共设施管理业",
              :居民服务修理和其他服务业 => "居民服务、修理和其他服务业",
              :教育 => "教育",
              :卫生和社会工作 => "卫生和社会工作",
              :娱乐业 => "文化、体育和娱乐业",
              :综合 => "综合"
  }

  PLATE = {:深市公司 => "sz",
           :深市主板 => "szmb",
           :中小板 => "szzx",
           :创业板 => "szcy",
           :沪市主板 => "shmb"
  }

  CATEGORY = {
      :年度报告 => "category_ndbg_szsh",
      :半年度报告 => "category_bndbg_szsh",
      :一季度报告 => "category_yjdbg_szsh",
      :三季度报告 => "category_sjdbg_szsh",
      :首次公开发行 => "category_scgkfx_szsh",
      :配股 => "category_pg_szsh",
      :增发 => "category_zf_szsh",
      :可转换债券 => "category_kzhz_szsh",
      :权证相关 => "category_qzxg_szsh",
      :其他融资 => "category_qtrz_szsh",
      :权益及限制出售 => "category_qyfpxzcs_szsh",
      :股权变动 => "category_gqbd_szsh",
      :交易 => "category_jy_szsh",
      :股东大会 => "category_gddh_szsh",
      :澄清分析业绩预告 => "category_cqfxyj_szsh",
      :特别处理和退市 => "category_tbclts_szsh",
      :补充及更正 => "category_bcgz_szsh",
      :中介机构报告 => "category_zjjg_szsh",
      :上市公司制度 => "category_ssgszd_szsh",
      :债券公告 => "category_zqgg_szsh",
      :其他重大事项 => "category_qtzdsx_szsh",
      :投资者关系 => "category_tzzgx_szsh",
      :董事会公告 => "category_dshgg_szsh",
      :监事会公告 => "category_jshgg_szsh"
  }


  def get_result(stock, industry, plate, report, start_time, end_time)
    params = {
        stock: stock,
        searchkey: '',
        plate: plate,
        category: report,
        trade: industry,
        column: 'szse_main',
        columnTitle: '历史公告查询',
        pageNum: p,
        pageSize: 50,
        tabName: 'fulltext',
        seDate: "#{start_time} ~ #{end_time}"
    }

    response = RestClient.post(URL, params)
    res = JSON.parse response.body
    Rails.logger.info '#### first_page #{res}'
    page_num = res["totalAnnouncement"]
    return  {status:0,msg:'无数据'} if page_num == 0
    if page_num < 50
      query(page_num,stock, industry, plate, report, start_time, end_time)
    else
      pages = (page_num/50.to_f).round
      query(pages,stock, industry, plate, report, start_time, end_time)
    end

  end

  def query(pages,stock, industry, plate, report, start_time, end_time)
    ary = []
    final_result = ''
    industry = industry
    plate = plate
    category = report
    pages.times do |p|
      params = {
          stock: stock,
          searchkey: '',
          plate: plate,
          category: report,
          trade: industry,
          column: 'szse_main',
          columnTitle: '历史公告查询',
          pageNum: p,
          pageSize: 50,
          tabName: 'fulltext',
          seDate: "#{start_time} ~ #{end_time}"
      }
      begin
        response = RestClient.post(URL, params)
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
              #content = read_pdf("#{URL_PERFIX}/#{adjunctUrl}")

              ary << {:industry => industry,
                      :plate => plate,
                      :category => category,
                      :title => announcementTitle,
                      :report_date => Time.at(time/1000),
                      :code => commpany_code,
                      :name => commpany_name,
                      :url => "#{URL_PERFIX}/#{adjunctUrl}",
                      #:content => content
              }
            end
          end
          final_result = {:status => 'success'}
        else
          final_result = {:status => 'fail'}
        end
      rescue RestClient::ExceptionWithResponse => err
        Rails.logger.info "#############{err.response}############"
      end
    end
    final_result
  end


  def read_pdf_ary(ary)
    Parallel.map(ary, in_processes: 10) { |a|
      read_pdf(a[:url])
    }
  end

  def read_pdf(url)
    content_ary = []
    p 'start reading '
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
      #self.context = s[:content]
      self.report_date = s[:report_date]
      self.save
    end
  end


end


