class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  after_create :save_gist_body!, if: :gist?

  def gist?
    gist_id.present?
  end

  def save_gist_body!
    gist_body = GistService.new(gist_id).call
    update! gist_body: gist_body
  end

  private

  def gist_id
    url.match(/https:\/\/gist.github.com\/\w+\/(\w+)/)[1] rescue nil
  end
end
