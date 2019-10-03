class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  def gist_content
    return gist_body unless gist_body.nil?

    contents = GistService.new(gist_id).call
    update(gist_body: contents)
    contents
  end

  def gist?
    gist_id
  end

  private

  def gist_id
    url.match(/https:\/\/gist.github.com\/\w+\/(\w+)/)[1] rescue nil
  end
end
