RSpec.shared_examples 'inserted middleware' do |modification|
  context ".#{modification}" do
    let(:processed_collection) { double('processed_collection') }
    let(:collection) { double('collection') }
    let(:params) { double('params') }

    def env
      @env ||= []
    end

    subject(:inspector) do
      # It writes result of evaluation of previous middleware into
      # `result_env` variable accessible in all examples.
      result_env = env

      lambda do |builder|
        builder.use ->(env) { (result_env << env).flatten! }
      end
    end

    subject(:fetch!) do
      # rubocop:disable Style/MultilineBlockChain
      Class.new(described_class) do
        def default_middleware
          ::Middleware::Builder.new
        end

        def process_params(params)
          [params, []]
        end
      end.tap do |klass|
        klass.resource_class = double('resource_class', all: collection)
        klass.send(modification, &test_probe)
        klass.middleware(&inspector)
      end.new(params).call
      # rubocop:enable Style/MultilineBlockChain
    end

    context 'when block returns tuple' do
      let(:processed_params) { double(Hash) }
      let(:test_probe) { ->(_resource, _params) { [processed_collection, processed_params] } }
      before { fetch! }

      it 'modify resource scope and leave params as is' do
        scope, parameters = env
        expect(scope).to eq(processed_collection)
        expect(parameters).to eq(processed_params)
      end
    end

    context 'when block returns invalid value' do
      let(:test_probe) { ->(_resource, _params) { processed_collection } }

      it 'modify resource scope and leave params as is' do
        expect do
          fetch!
        end.to raise_error { |e|
          expect(e.message).to eq('After block must return tuple of scope and params')
        }
      end
    end
  end
end
