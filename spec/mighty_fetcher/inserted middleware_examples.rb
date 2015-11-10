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

      ->(env) { (result_env << env).flatten! }
    end

    subject(:fetch!) do
      Class.new(described_class).tap do |klass|
        klass.resource_class = double('resource_class', all: collection)
        klass.middleware = ::Middleware::Builder.new
        klass.send(modification, &test_probe)
        klass.middleware.use inspector
      end.new(params).call
    end

    context 'when block with one argument given' do
      let(:test_probe) { ->(_resource) { processed_collection } }
      before { fetch! }

      it 'modify resource scope and leave params as is' do
        scope, parameters = env
        expect(scope).to eq(processed_collection)
        expect(parameters).to eq(params)
      end
    end

    context 'when block with two arguments given' do
      let(:processed_params) { double(Hash) }
      let(:test_probe) { ->(_resource, _params) { [processed_collection, processed_params] } }
      before { fetch! }

      it 'modify resource scope and leave params as is' do
        scope, parameters = env
        expect(scope).to eq(processed_collection)
        expect(parameters).to eq(processed_params)
      end
    end

    context 'when block with two arguments returns invalid value' do
      let(:test_probe) { ->(_resource, _params) { processed_collection } }

      it 'modify resource scope and leave params as is' do
        expect do
          fetch!
        end.to raise_error { |e|
          expect(e.message).to eq('After block must return tuple of scope and params')
        }
      end
    end

    context 'when block with invalid arity given' do
      let(:test_probe) { ->(_a, _b, _c) {} }

      it 'modify resource scope and leave params as is' do
        expect do
          fetch!
        end.to raise_error { |e|
          expect(e.message).to eq('Wrong number of arguments (3 for 0..2)')
        }
      end
    end
  end
end
