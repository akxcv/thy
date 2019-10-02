# frozen_string_literal: true

module Thy
  module Types
    class Hash
      def initialize(schema)
        @schema = schema
        @schema_length = schema.length
        @schema_keys = schema.keys
      end

      def check(value)
        unless value.is_a?(::Hash)
          return Result::Failure.new("Expected a Hash, but got: #{value.inspect}")
        end
        if @schema_length != value.length
          return Result::Failure.new("Expected #{value.inspect} to contain #{@schema_length} keys")
        end
        if @schema_keys & value.keys != @schema_keys
          return Result::Failure.new(
            "Expected #{value.inspect} to contain keys: #{@schema_keys.inspect}",
          )
        end

        @schema.each do |k, t|
          v = value.fetch(k)

          if t.check(v).failure?
            return Result::Failure.new("Expected #{v.inspect} to be of type #{t.inspect}")
          end
        end

        Result::Success
      end
    end
  end
end
