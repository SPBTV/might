require 'mighty_fetcher/base'

RSpec.describe MightyFetcher::Base, 'middleware stack builder' do
  require_relative 'inserted middleware_examples'
  include_examples 'inserted middleware', :after
  include_examples 'inserted middleware', :before

  context 'modification and DSL methods', database: true do
    require 'database_helper'

    let(:page) { Page.first }

    describe '.filter' do
      let(:params) do
        { filter: { 'name_eq' => page.name } }
      end

      subject { page_fetcher.new(params).call }

      context 'when filter applied after middleware modification' do
        let(:page_fetcher) do
          Class.new(MightyFetcher::Base) do
            after do |scope, params|
              [scope, params]
            end

            filter :name

            self.resource_class = Page
          end
        end

        it 'it may be filtered' do
          is_expected.to contain_exactly(page)
        end
      end

      context 'when filter applied before middleware modification' do
        let(:page_fetcher) do
          Class.new(MightyFetcher::Base) do
            filter :name

            after do |scope, params|
              [scope, params]
            end

            self.resource_class = Page
          end
        end

        it 'it may be filtered' do
          is_expected.to contain_exactly(page)
        end
      end
    end
  end
end
