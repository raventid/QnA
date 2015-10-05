module SphinxHelpers
  def index
    ThinkingSphinx::Test.index
    sleep 1 until index_finished?
  end

  def index_finished?
    Dir[Rails.root.join(ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}*')].empty?
  end
end