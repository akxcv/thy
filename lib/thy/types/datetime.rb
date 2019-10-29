# frozen_string_literal: true

module Thy
  module Types
    module DateTime
      def self.check(value)
        if value.is_a?(::DateTime)
          Result::Success
        else
          Result::Failure.new("Expected DateTime, but got: #{value.inspect}")
        end
      end
    end
  end
end
