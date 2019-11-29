class ReputationJob < ApplicationJob
  queue_as :default

  def perform(obj)
    Services::Reputation.calculate(obj)
  end
end
