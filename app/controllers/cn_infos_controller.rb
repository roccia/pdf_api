class CnInfosController < ApplicationController

  def index

  end

  def create
    @cn_info = CnInfo.new

    res = @cn_info.get_result(params)

     Rails.logger.info "controller_result #{res}"
    render  json: {:status=> 'no_data'} if res[:status] == 0
    if res[:status] == 'success'
      @cn_info.stock_num = params['stock']
      @cn_info.context = res[:msg]
      @cn_info.save
      ArticleJob.perform_later(@cn_info.id)
      render json: {:status=> 'success' }
    elsif res[:status] == 'exist'
      render json: {:status=> 'data_exist'}
    else
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
