require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:query) { 'query_text' }
  let(:incorrect_classname) { 'f14saflsfl32dkja54s' }

  describe '#search' do
    it 'with empty query' do
      expect(Search.search(nil)).to be_nil
    end

    it 'within ALL classes' do
      expect(ThinkingSphinx).to receive(:search).with(query, classes: [])
      Search.search query
    end

    it 'within CONFIRMED classes' do
      Search::SEARCHING_SOURCES.first do |source|
        expect(ThinkingSphinx).to receive(:search).with(query, classes: [source.classify.constantize])
        Search.search query, source
      end
    end

    it 'with incorrect source class' do
      expect(ThinkingSphinx).to receive(:search).with(query, classes: [])
      Search.search query, incorrect_classname
    end
  end
end
