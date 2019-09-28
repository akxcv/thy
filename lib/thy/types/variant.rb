# frozen_string_literal: true

module Thy
  module Types
    class Variant
      def initialize(types)
        @types = types
      end

      def check(value)
        if @types.any? { |t| t.check(value).success? }
          Result::Success
        else
          Result::Failure.new("Expected #{value.inspect} to be within types: #{@types.inspect}")
        end
      end
    end
  end
end
