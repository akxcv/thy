# frozen_string_literal: true

module Thy
  module Types
    module Float
      def self.check(value)
        if value.is_a?(::Float)
          Result::Success
        else
          Result::Failure.new("Expected a Float, but got: #{value.inspect}")
        end
      end
    end
  end
end
