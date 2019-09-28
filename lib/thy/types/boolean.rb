# frozen_string_literal: true

module Thy
  module Types
    module Boolean
      def self.check(value)
        if value == true || value == false
          Result::Success
        else
          Result::Failure.new("Expected a boolean value, but got: #{value.inspect}")
        end
      end
    end
  end
end
