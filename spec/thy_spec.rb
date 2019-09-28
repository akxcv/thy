# frozen_string_literal: true

RSpec.describe Thy do
  context 'primitive types' do
    TYPE_EXAMPLES = {
      String: %w[kek pek cheburek],
      Symbol: %i[kek pek cheburek],
      Numeric: [1, 2, 3, -1, 0.5],
      Float: [0.1, 123.123, -69.69],
      Integer: [0, 1, -1, -100, 123],
      Boolean: [true, false],
    }.freeze

    PRIMITIVE_TYPES = TYPE_EXAMPLES.keys

    PRIMITIVE_TYPES.each do |type_name|
      it "checks #{type_name} correctly" do
        valid_example = TYPE_EXAMPLES[type_name].sample

        counterexample_keys = TYPE_EXAMPLES.keys - [type_name]
        counterexample_keys -= %i[Numeric] if type_name == :Float || type_name == :Fnteger
        counterexample_keys -= %i[Float Integer] if type_name == :Numeric

        invalid_example = TYPE_EXAMPLES[counterexample_keys.sample].sample

        type = described_class.const_get(type_name)

        expect(type.check(valid_example).success?).to eq(true)

        expect(type.check(invalid_example).success?).to eq(false)
        expect(type.check(nil).success?).to eq(false)
      end
    end
  end

  context 'complex types' do
    it 'provides enums' do
      enum = described_class::Variant(described_class::String, described_class::Integer)

      expect(enum.check('kek').success?).to eq(true)
      expect(enum.check(1).success?).to eq(true)

      expect(enum.check(:kek).success?).to eq(false)
    end

    it 'provides value enums' do
      enum = described_class::Enum(:kek, :pek, 69)

      expect(enum.check(:kek).success?).to eq(true)
      expect(enum.check(:pek).success?).to eq(true)
      expect(enum.check(69).success?).to eq(true)

      expect(enum.check(:cheburek).success?).to eq(false)
      expect(enum.check(123).success?).to eq(false)
    end

    it 'provides optionals' do
      opt = described_class::Option(described_class::String)

      expect(opt.check(nil).success?).to eq(true)
      expect(opt.check('kek').success?).to eq(true)

      expect(opt.check(1).success?).to eq(false)
    end

    context 'arrays' do
      it 'provides typed arrays' do
        arr = described_class::Array(described_class::String)

        expect(arr.check(%w[kek pek]).success?).to eq(true)
        expect(arr.check(%w[1 2]).success?).to eq(true)
        expect(arr.check([]).success?).to eq(true)

        expect(arr.check([1, 2]).success?).to eq(false)
        expect(arr.check(['kek', 69]).success?).to eq(false)
        expect(arr.check('cheburek').success?).to eq(false)
      end

      it 'provides untyped arrays' do
        arr = described_class::UntypedArray

        expect(arr.check(%w[kek pek]).success?).to eq(true)
        expect(arr.check([]).success?).to eq(true)
        expect(arr.check([1, 2, 'kek']).success?).to eq(true)

        expect(arr.check(nil).success?).to eq(false)
        expect(arr.check('cheburek').success?).to eq(false)
      end
    end

    context 'hashes' do
      context 'typed hashes' do
        specify 'basic usage' do
          hsh = described_class::Hash(kek: described_class::Integer, pek: described_class::String)

          expect(hsh.check(kek: 1, pek: 'kek').success?).to eq(true)

          expect(hsh.check(kek: 'pek', pek: 'kek').success?).to eq(false)
          expect(hsh.check(kek: 1, pek: 1).success?).to eq(false)
          expect(hsh.check('kek' => 1, pek: 'kek').success?).to eq(false)
          expect(hsh.check(kek: 1, pek: 'kek', cheburek: 1).success?).to eq(false)
          expect(hsh.check(kek: 1).success?).to eq(false)
          expect(hsh.check('cheburek').success?).to eq(false)
        end
      end

      specify 'untyped hashes' do
        hsh = described_class::UntypedHash

        expect(hsh.check({}).success?).to eq(true)
        expect(hsh.check(1 => 2).success?).to eq(true)
        expect(hsh.check(kek: :kek, 'pek' => {}).success?).to eq(true)

        expect(hsh.check('sdkfs').success?).to eq(false)
      end

      specify 'maps' do
        hsh = described_class::Map(described_class::Integer, described_class::Symbol)

        expect(hsh.check(1 => :kek).success?).to eq(true)
        expect(hsh.check(1 => :kek, 2 => :pek).success?).to eq(true)
        expect(hsh.check({}).success?).to eq(true)

        expect(hsh.check('cheburek').success?).to eq(false)
        expect(hsh.check(kek: 1).success?).to eq(false)
        expect(hsh.check(1 => 'kek').success?).to eq(false)
      end
    end
  end

  context 'custom types' do
    it 'allows to register basic custom types' do
      non_zero_integer = described_class::Type.new { |v| v.is_a?(Integer) && v != 0 }

      expect(non_zero_integer.check(0).success?).to eq(false)

      expect(non_zero_integer.check(10).success?).to eq(true)
      expect(non_zero_integer.check(-69).success?).to eq(true)
    end

    it 'allows to register complex types' do
      string_like = described_class::Variant(described_class::String, described_class::Symbol)

      expect(string_like.check('kek').success?).to eq(true)
      expect(string_like.check(:kek).success?).to eq(true)

      expect(string_like.check(1).success?).to eq(false)
    end

    it 'allows to refine types' do
      positive_integer = described_class.refine_type(
        described_class::Integer,
        described_class::Type.new { |v| v > 0 },
      )

      expect(positive_integer.check(1).success?).to eq(true)
      expect(positive_integer.check(0).success?).to eq(false)
      expect(positive_integer.check(3.14).success?).to eq(false)
      expect(positive_integer.check(-1).success?).to eq(false)
    end
  end

  describe 'type composition' do
    let(:non_zero_integer) do
      described_class::refine_type(
        described_class::Integer,
        described_class::Type.new { |v| v != 0 },
      )
    end

    let(:user_type) do
      described_class::Hash(
        email: described_class::String,
        password: described_class::String,
        age: described_class::Option(non_zero_integer),
        nicknames: described_class::Array(described_class::String),
        restrictions: described_class::Map(described_class::Symbol, described_class::Boolean),
      )
    end

    let(:valid_users) do
      [
        {
          email: 'cow@cow.cow',
          password: '12345',
          age: 19,
          nicknames: %w[vova petya],
          restrictions: {
            kek: true,
            pek: false,
          },
        },
        {
          email: 'cow@cow.cow',
          password: '',
          age: nil,
          nicknames: [],
          restrictions: {},
        },
      ]
    end

    let(:invalid_users) do
      [
        {
          password: '12345',
          age: nil,
          nicknames: [],
          restrictions: {},
        },
        {
          email: 'cow@cow.cow',
          password: '12345',
          age: nil,
          nicknames: 'kek',
          restrictions: {},
        },
        {
          email: 'cow@cow.cow',
          password: '12345',
          age: nil,
          nicknames: [],
          restrictions: {
            1 => 2,
          },
        },
      ]
    end

    specify do
      valid_users.each do |valid_user|
        expect(user_type.check(valid_user).success?).to eq(true)
      end

      invalid_users.each do |invalid_user|
        expect(user_type.check(invalid_user).success?).to eq(false)
      end
    end
  end
end
