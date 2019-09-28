# frozen_string_literal: true

module Thy
  module Types
    class Array
      def initialize(type)
        @type = type
      end

      def check(values)
        unless values.is_a?(::Array)
          return Result::Failure.new("Expected an array, but got #{values.inspect}")
        end

        values.each do |value|
          if @type.check(value).failure?
            return Result::Failure.new(
              "Expected an array of #{@type.inspect}, but got element: #{value.inspect}",
            )
          end
        end

        Result::Success
      end
    end
  end
end
