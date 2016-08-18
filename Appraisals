require 'yaml'

ruby_versions = %w(2.2.5 2.3.1)
rails_versions = %w(4.2.7 5.0.0)
ransack_versions = %w(1.6.6 1.8.2)

rails_versions.product(ransack_versions).each do |(rails, ransack)|
  appraise "rails_#{rails}_ransack_#{ransack}" do
    gem 'activerecord', rails
    gem 'activesupport', rails
    gem 'ransack', ransack
  end
end

::File.open('.travis.yml', 'w+') do |f|
  travis_hash = {
    'language' => 'ruby',
    'rvm' => ruby_versions,
    'script'  => [
      'bundle exec rake spec',
      'bundle exec rubocop --fail-level C'
    ],
    'gemfile' => Dir.glob('gemfiles/*.gemfile')
  }
  travis = ::YAML.dump(travis_hash)
  f.write travis
end
