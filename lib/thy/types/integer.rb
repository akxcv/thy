# frozen_string_literal: true

module Thy
  module Types
    module Integer
      def self.check(value)
        if value.is_a?(::Integer)
          Result::Success
        else
          Result::Failure.new("Expected an Integer, but got: #{value.inspect}")
        end
      end
    end
  end
end
