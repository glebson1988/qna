class Services::Search

  SCOPES = %w[thinking_sphinx user comment question answer].freeze

  def self.call(query)
    return unless SCOPES.include?(query[:scope])
    
    query[:scope].classify.constantize.search(ThinkingSphinx::Query.escape(query[:query]))
  end
end
