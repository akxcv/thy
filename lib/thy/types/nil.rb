# frozen_string_literal: true

module Thy
  module Types
    module Nil
      def self.check(value)
        if value.nil?
          Result::Success
        else
          Result::Failure.new("Expected nil, but got: #{value.inspect}")
        end
      end
    end
  end
end
