class CnInfosController < ApplicationController

  def index

  end

  def create

    s = params[:stock]
    i = params[:industry]
    p = params[:plate]
    r = params[:report]
    start_time = params[:start_time]
    end_time = params[:end_time]
    cn_info = CnInfo.new(s,i,p,r,start_time,end_time)

    res = cn_info.get_result

    Rails.logger.info "controller_result #{res}"
    if res[:status] == 0
      render  json: {:status=> 'no_data', :msg => '无数据'}
    elsif res[:status] == 'success'
      render json: {:status=> 'success', :msg => '爬取成功' }
    else
      render  json: {:status=> 'failed', :msg => '爬取失败'}
    end

  end

  private
  def set_cn_info
    @cn_info = CnInfo.find(params[:id])
  end

  def cn_info_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)

    # params.require(:cn_info).permit(:id, :industry, :plate, :category, :company_name,
    #                                 :company_code, :url, :title,:context)
  end

end
