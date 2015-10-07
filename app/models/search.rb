class Search < ActiveRecord::Base
  SEARCHING_SOURCES = %w(Question Answer Comment User)

  def self.search(query, source = nil)
    return unless query

    escaped_query = Riddle::Query.escape(query)
    classes = []
    if source && SEARCHING_SOURCES.include?(source)
      classes << source.classify.constantize
    end
    ThinkingSphinx.search escaped_query, classes: classes
  end

  private

  def indiceable_classes
    %w(Question Answer Comment User)
  end
end
