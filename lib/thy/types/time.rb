# frozen_string_literal: true

module Thy
  module Types
    module Time
      def self.check(value)
        if value.is_a?(::Time)
          Result::Success
        else
          Result::Failure.new("Expected Time, but got: #{value.inspect}")
        end
      end
    end
  end
end
