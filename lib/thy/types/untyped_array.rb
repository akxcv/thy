# frozen_string_literal: true

module Thy
  module Types
    module UntypedArray
      def self.check(value)
        if value.is_a?(::Array)
          Result::Success
        else
          Result::Failure.new("Expected an Array, but got: #{value.inspect}")
        end
      end
    end
  end
end
