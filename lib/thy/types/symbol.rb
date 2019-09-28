# frozen_string_literal: true

module Thy
  module Types
    module Symbol
      def self.check(value)
        if value.is_a?(::Symbol)
          Result::Success
        else
          Result::Failure.new("Expected a Symbol, but got: #{value.inspect}")
        end
      end
    end
  end
end
