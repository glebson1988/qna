class Services::DailyDigest
  def self.call
    return if Question.where(created_at: Date.yesterday.all_day).empty?

    User.find_each { |user| DailyDigestMailer.digest(user).deliver_later }
  end
end
