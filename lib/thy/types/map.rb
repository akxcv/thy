# frozen_string_literal: true

module Thy
  module Types
    class Map
      def initialize(key_type, value_type)
        @key_type = key_type
        @value_type = value_type
      end

      def check(value)
        unless value.is_a?(::Hash)
          return Result::Failure.new("Expected a Hash, but got: #{value.inspect}")
        end

        value.keys.each do |k|
          if @key_type.check(k).failure?
            return Result::Failure.new(
              "Expected key #{k.inspect} to be of type #{@key_type.inspect}",
            )
          end
        end

        value.values.each do |v|
          if @value_type.check(v).failure?
            return Result::Failure.new(
              "Expected value #{v.inspect} to be of type #{@value_type.inspect}",
            )
          end
        end

        Result::Success
      end
    end
  end
end
