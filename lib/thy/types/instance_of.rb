# frozen_string_literal: true

module Thy
  module Types
    class InstanceOf
      def initialize(klass)
        @klass = klass
      end

      def check(value)
        if value.is_a?(@klass)
          Result::Success
        else
          Result::Failure.new("Expected #{value.inspect} to be an instance of: #{@klass.inspect}")
        end
      end
    end
  end
end
