class CnInfosController < ApplicationController

  def index

  end

  def create
    @cn_info = CnInfo.new

    res = @cn_info.get_result(params)

     Rails.logger.info "controller_result #{res}"
    case res[:status]
      when res[:status] == -2
        render  json: {:status=> '请传入时间'}
      when res[:status] == 0
        render  json: {:status=> 'no_data'}
      when res[:status] == 'success'
        render json: {:status=> 'success' }
      when res[:status] == 'exist'
        render json: {:status=> 'data_exist'}
      when res[:status] == 'fail'
        render  json: {:status=> 'failed'}

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
