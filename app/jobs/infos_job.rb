class InfosJob < ActiveJob::Base
  queue_as :default

  def perform(id,stock,industry,plate,report,start_time,end_time)
    res =  CnInfo.find id
    res.get_result(stock,industry,plate,report,start_time,end_time)
  end
end
