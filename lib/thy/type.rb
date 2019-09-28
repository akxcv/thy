# frozen_string_literal: true

module Thy
  class Type
    def initialize(&checker)
      @checker = checker
    end

    def check(value)
      check_result = @checker.call(value)

      return Result::Success if check_result == true
      return Result::Failure.new('No message provided') if check_result == false

      check_result
    end
  end
end
