# frozen_string_literal: true

module Thy
  module Types
    class Enum
      def initialize(values)
        @values = values
      end

      def check(value)
        if @values.any? { |v| value == v }
          Result::Success
        else
          Result::Failure.new("Expected #{value.inspect} to be one of: #{@values.inspect}")
        end
      end
    end
  end
end
