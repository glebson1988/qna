class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  after_create :gist?

  def gist?
    update!(gist_body: GistService.new(gist_id).call) unless gist_id.nil?
  end

  private

  def gist_id
    url.match(/https:\/\/gist.github.com\/\w+\/(\w+)/)[1] rescue nil
  end
end
