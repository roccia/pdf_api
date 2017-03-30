class CnInfosController < ApplicationController

  def create
    @cn_info = CnInfo.new(cn_info_params)
    p params
    stock = params[:stock]
    industry = params[:industry]
    plate = params[:plate]
    report = params[:report]
    start_time = params[:start_time]
    end_time = params[:end_time]

    res =  @cn_info.get_result(stock,industry,plate,report,start_time,end_time)

    if res[:status] == 1
       render json: {:status=> 'success', :msg => res[:msg]}
    else
      render  json: {:status=> 'failed', :msg => 'none'}
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
