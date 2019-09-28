# frozen_string_literal: true

module Thy
  module Types
    module String
      def self.check(value)
        if value.is_a?(::String)
          Result::Success
        else
          Result::Failure.new("Expected a String, but got: #{value.inspect}")
        end
      end
    end
  end
end
