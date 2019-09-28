# frozen_string_literal: true

module Thy
  module Types
    class Option
      def initialize(type)
        @type = type
      end

      def check(value)
        return Result::Success if value.nil?

        if @type.check(value).success?
          Result::Success
        else
          Result::Failure.new("Expected #{value.inspect} to be of type #{@type.inspect}")
        end
      end
    end
  end
end
