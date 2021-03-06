# frozen_string_literal: true
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: :sqlite3,
  encoding: :utf8,
  pool: 5,
  timeout: 5000,
  database: ':memory:',
  verbosity: :quiet,
)

module Schema
  def self.create
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do
      create_table :pages, force: true do |t|
        t.string :name
        t.string :slug
      end
    end
  end
end

require 'fixtures/page'

RSpec.configure do |config|
  config.before :all, database: true do
    Schema.create
    3.times { |n| Page.create!(name: "Page ##{n}") }
  end

  config.after :all, database: true do
    Page.delete_all
  end
end
