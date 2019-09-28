# frozen_string_literal: true

module Thy
  module Result
    class Failure
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def success?
        false
      end

      def failure?
        true
      end
    end
  end
end
