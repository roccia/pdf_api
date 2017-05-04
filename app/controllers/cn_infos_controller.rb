class CnInfosController < ApplicationController

  def index

  end

  def create
    @cn_info = CnInfo.new

   #res =  InfosJob.perform_later(@cn_info)
    res = @cn_info.get_result(params)

    Rails.logger.info "controller_result #{res}"
    if res[:status] == 0
      render  json: {:status=> 'no_data', :msg => '无数据'}
    elsif res[:status] == 'success'
      Rails.logger.info res[:msg]
       @cn_info.save_to_db(res[:msg])
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
