# frozen_string_literal: true

module Thy
  module Result
    module Success
      def self.success?
        true
      end

      def self.failure?
        false
      end
    end
  end
end
