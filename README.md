# Thy [![Build Status](https://travis-ci.org/akxcv/thy.svg?branch=master)](https://travis-ci.org/akxcv/thy)

Thy is a minimal, strict runtime type system for Ruby.

## Motivation

There are many existing runtime type systems for Ruby, most notably, dry-types. Here's why you might
prefer Thy:

- Thy encourages strictness. Avoiding type coercion as much as possible is an excellent way to keep
your code predictable and straightforward.
- Minimalism. Thy's API only has what's needed, nothing more.
- No Any type. Don't worry, if you *have to*, you [can get it](#custom-types)!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thy

## Usage

It's recommended not to use Thy directly (although [you can](#direct-usage)), but to create a module
for working with types, and to include `Thy::Types` into it.

```ruby
module Types
  include Thy::Types
end
```

To run a type check, call `check` on a type you need. For example:

```ruby
module Types
  include Thy::Types
end

Types::String.check('a string').success? # => true
Types::Integer.check(3.14).success?      # => false
```

If a check fails, a message describing the failure is provided:

```ruby
Types::String.check(3).failure? # => true
Types::String.check(3).message # => "Expected a String, but got: 3"
```

### Custom types

Thy allows you to define custom types via `Thy::Type`'s constructor:

```ruby
module Types
  include Thy::Types

  NonZeroValue = Thy::Type.new { |value| value != 0 }
end
```

#### Providing meaningful error messages

```ruby
module Types
  include Thy::Types

  NonZeroValue = Thy::Type.new do |value|
    value != 0 || Thy::Result::Failure.new("Expected #{value.inspect} to be nonzero")
  end
end
```

#### Building on top of existing types

Extending existing types is simple, too:

```ruby
module Types
  include Thy::Types

  NonZeroInteger = Thy.refine_type(Integer, Thy::Type.new { |v| v != 0 })
end
```

### Direct usage

You can use Thy types directly, for example, if you'd like to play around in the console:

```ruby
Thy::String.check('Bob').success? # => true
PositiveInteger = Thy.refine_type(Integer, Thy::Type.new { |v| v > 0 })
```

## Built-in type reference

### Primitive types

```ruby
# String
Thy::String.check('Bob').success? # => true

# Symbol
Thy::Symbol.check(:bob).success? # => true

# Numeric
Thy::Numeric.check(3.14).success? # => true
Thy::Numeric.check(0).success? # => true

# Float
Thy::Float.check(3.14).success? # => true

# Integer
Thy::Integer.check(3).success? # => true

# Boolean
Thy::Boolean.check(true).success? # => true
Thy::Boolean.check(false).success? # => true

# Time
Thy::Time.check(Time.now).success? # => true
Thy::Time.check(0).success? # => false

# DateTime
require 'date'
Thy::DateTime.check(DateTime.now).success? # => true
Thy::DateTime.check(0).success? # => false

# nil
Thy::Nil.check(nil).success? # => true
Thy::Nil.check(0).success? # => false
```

### Parameterized types

```ruby
# Array
Thy::Array(Thy::Integer).check([1, 2, 3]).success? # => true
Thy::Array(Thy::String).check(%w[hi hello sup]).success? # => true

# Hash
Thy::Hash({
  name: Thy::String,
  age: Thy::Integer,
}).check({ name: 'Bob', age: 18 }).success? # => true

# Map
Thy::Map(Thy::Symbol, Thy::Integer).check({ a: 1, b: 2 }).success? # => true

# Variant
Thy::Variant(Thy::Integer, Thy::Float).check(3.14).success? # => true
Thy::Variant(Thy::Integer, Thy::Float).check(3).success? # => true

# Enum
Thy::Enum('USD', 'EUR').check('EUR').success? # => true

# Option
Thy::Option(Thy::String).check('a string').success? # => true
Thy::Option(Thy::String).check(nil).success? # => true

# InstanceOf
class A; end
class B < A; end
class C; end
Thy::InstanceOf(A).check(B.new).success? # => true
Thy::InstanceOf(A).check(C.new).success? # => false

# ClassExtending
Thy::ClassExtending(A).check(B).success? # => true
Thy::ClassExtending(A).check(C).success? # => false
```

### Other types

```ruby
# UntypedArray
Thy::UntypedArray.check(1, 'string', 3.14).success? # => true

# UntypedHash
Thy::UntypedHash.check({ a: 1, b: 'c', 1 => true }).success? # => true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akxcv/thy.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
