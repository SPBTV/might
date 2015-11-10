require 'mighty_fetcher/validation_error'

RSpec.describe MightyFetcher::ValidationError, '#message' do
  let(:error) { described_class.new(messages) }
  subject { error.message }

  context 'when one error message given' do
    let(:messages) { 'foo' }

    it 'returns this message' do
      is_expected.to eq('foo')
    end
  end

  context 'when multiple error messages given' do
    let(:messages) { %w(foo bar) }

    it 'returns comma separated list of this messages' do
      is_expected.to eq('foo, bar')
    end
  end
end
