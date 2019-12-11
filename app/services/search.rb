class Services::Search

  SCOPES = %w[thinking_sphinx user comment question answer].freeze

  def self.call(query)
    return unless SCOPES.include?(query[:scope])
    
    escaped_query = ThinkingSphinx::Query.escape(query[:query])
    klass = query[:scope].classify.constantize
    klass.search(escaped_query)
  end
end
