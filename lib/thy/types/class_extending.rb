# frozen_string_literal: true

module Thy
  module Types
    class ClassExtending
      def initialize(klass)
        @klass = klass
      end

      def check(value)
        unless value.is_a?(::Class)
          return Failure.new("Expected #{value.inspect} to be a Class")
        end

        if value.ancestors.include?(@klass)
          Result::Success
        else
          Result::Failure.new(
            "Expected #{value.inspect} to be a descendant of: #{@klass.inspect}",
          )
        end
      end
    end
  end
end
