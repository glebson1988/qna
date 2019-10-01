class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  def gist_content
    @gist_content ||= GistService.new(gist_id).call
  end

  def gist?
    gist_id
  end

  private

  def gist_id
    url.match(/https:\/\/gist.github.com\/\w+\/(\w+)/)[1] rescue nil
  end
end
