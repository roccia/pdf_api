class InfosJob < ActiveJob::Base
  queue_as :default

  def perform(cn_info)
    cn_info.get_result
  end
end
