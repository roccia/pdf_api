class InfosJob < ActiveJob::Base
  queue_as :default

  def perform(cn_info,stock,industry,plate,report,start_time,end_time)

    cn_info.get_result(stock,industry,plate,report,start_time,end_time)

  end
end
