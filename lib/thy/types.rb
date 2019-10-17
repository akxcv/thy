# frozen_string_literal: true

module Thy::Types
  def self.included(mod)
    mod.extend(ClassMethods)
  end

  module ClassMethods
    # rubocop:disable Naming/MethodName
    def Array(type)
      Array.new(type)
    end

    def Hash(schema)
      Hash.new(schema)
    end

    def Map(key_type, value_type)
      Map.new(key_type, value_type)
    end

    def Enum(*types)
      Enum.new(types)
    end

    def Variant(*values)
      Variant.new(values)
    end

    def Option(type)
      Option.new(type)
    end

    def InstanceOf(klass)
      InstanceOf.new(klass)
    end

    def ClassExtending(klass)
      ClassExtending.new(klass)
    end
    # rubocop:enable Naming/MethodName
  end
end
