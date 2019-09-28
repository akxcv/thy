# frozen_string_literal: true

module Thy
  module Types
    module UntypedHash
      def self.check(value)
        if value.is_a?(::Hash)
          Result::Success
        else
          Result::Failure.new("Expected a Hash, but got: #{value.inspect}")
        end
      end
    end
  end
end
