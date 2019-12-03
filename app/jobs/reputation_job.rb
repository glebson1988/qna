class ReputationJob < ApplicationJob
  queue_as :default

  def perform(obj)
    Services::Reputation.call(obj)
  end
end
