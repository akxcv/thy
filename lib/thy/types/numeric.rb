# frozen_string_literal: true

module Thy
  module Types
    module Numeric
      def self.check(value)
        if value.is_a?(::Numeric)
          Result::Success
        else
          Result::Failure.new("Expected a Numeric, but got: #{value.inspect}")
        end
      end
    end
  end
end
