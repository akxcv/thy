# frozen_string_literal: true

require 'thy/type'
require 'thy/types'

require 'thy/types/string'
require 'thy/types/symbol'
require 'thy/types/numeric'
require 'thy/types/integer'
require 'thy/types/float'
require 'thy/types/boolean'
require 'thy/types/nil'

require 'thy/types/time'
require 'thy/types/datetime'

require 'thy/types/array'
require 'thy/types/untyped_array'

require 'thy/types/hash'
require 'thy/types/untyped_hash'
require 'thy/types/map'

require 'thy/types/enum'
require 'thy/types/variant'

require 'thy/types/option'

require 'thy/types/instance_of'
require 'thy/types/class_extending'

require 'thy/result/success'
require 'thy/result/failure'

module Thy
  UntypedArray = Types::UntypedArray
  UntypedHash = Types::UntypedHash
  String = Types::String
  Symbol = Types::Symbol
  Numeric = Types::Numeric
  Float = Types::Float
  Integer = Types::Integer
  Boolean = Types::Boolean

  include Types

  class << self
    def refine_type(type_1, type_2)
      Type.new do |value|
        check_1 = type_1.check(value)
        if check_1.success?
          type_2.check(value)
        else
          check_1
        end
      end
    end
  end
end
