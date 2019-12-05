class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    Services::DailyDigest.call
  end
end
