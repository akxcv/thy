# frozen_string_literal: true

require 'thy/type'

require 'thy/types/string'
require 'thy/types/symbol'
require 'thy/types/numeric'
require 'thy/types/integer'
require 'thy/types/float'
require 'thy/types/boolean'

require 'thy/types/array'
require 'thy/types/untyped_array'

require 'thy/types/hash'
require 'thy/types/untyped_hash'
require 'thy/types/map'

require 'thy/types/enum'
require 'thy/types/variant'

require 'thy/types/option'

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

    # rubocop:disable Naming/MethodName
    def Array(type)
      Types::Array.new(type)
    end

    def Hash(schema)
      Types::Hash.new(schema)
    end

    def Map(key_type, value_type)
      Types::Map.new(key_type, value_type)
    end

    def Enum(*types)
      Types::Enum.new(types)
    end

    def Variant(*values)
      Types::Variant.new(values)
    end

    def Option(type)
      Types::Option.new(type)
    end
    # rubocop:enable Naming/MethodName
  end
end
