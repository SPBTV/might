# frozen_string_literal: true
require 'set'
require 'forwardable'
require 'active_model'
require 'active_support'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/concern'
require 'active_support/callbacks'
require 'middleware'
require 'uber/inheritable_attr'

# Top level namespace for mighty fetchers
module Might
  require 'might/version'
  extend ActiveSupport::Autoload

  autoload :Fetcher
  autoload :FetcherError
  autoload :FilterMiddleware
  autoload :FilterParameter
  autoload :FilterParameterDefinition
  autoload :FilterParameters
  autoload :FilterParametersExtractor
  autoload :FilterParametersValidator
  autoload :FilterPredicates
  autoload :FilterUndefinedParameter
  autoload :FilterValueValidator
  autoload :PaginationMiddleware
  autoload :PaginationParametersValidator
  autoload :Paginator
  autoload :RansackableFilter
  autoload :RansackableFilterParametersAdapter
  autoload :RansackableSort
  autoload :RansackableSortParametersAdapter
  autoload :Result
  autoload :Failure, 'might/result'
  autoload :Success, 'might/result'
  autoload :SortMiddleware
  autoload :SortParameter
  autoload :FilterUndefinedParameter
  autoload :SortParameterDefinition
  autoload :SortParametersExtractor
  autoload :SortParametersValidator
  autoload :SortUndefinedParameter
  autoload :SortValueValidator
  autoload :VERSION
end
