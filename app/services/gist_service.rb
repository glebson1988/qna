class GistService

  def initialize(gist_id, client = octokit_client)
    @gist_id = gist_id
    @client = client
  end

  def call
    begin
      gist = @client.gist(@gist_id)
      gist[:files].first[1][:content]
    rescue Octokit::NotFound
      false
    end
  end

  private

  def octokit_client
    Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
  end
end
