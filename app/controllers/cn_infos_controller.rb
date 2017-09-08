class CnInfosController < ApplicationController

  def index

  end

  def create
    @cn_info = CnInfo.find_or_create_by(stock_num:params[:stock])

    res = @cn_info.get_result(params)

     Rails.logger.info "controller_result #{res}"

      if res[:status] == -2
        render  json: {:status=> '请传入时间'}
      elsif res[:status] == 0
        render  json: {:status=> 'no_data'}
      elsif res[:status] == 'success'
         ArticleJob.perform_later(@cn_info.id)
         render json: {:status=> 'success' }
      elsif res[:status] == 'exist'
        render json: {:status=> 'data_exist'}
      else
        render json: {:status=> 'failed'}
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
