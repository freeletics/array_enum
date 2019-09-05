require "test_helper"

class SubsetValidatorTest < Minitest::Test
  class CreateUser
    include ActiveModel::Model

    attr_accessor :favourite_colors

    validates :favourite_colors, subset: ["green", "blue"]
  end

  class CreateUserWithProc
    include ActiveModel::Model

    attr_accessor :favourite_colors

    validates :favourite_colors, subset: { in: ->(record) { ["green", "blue"] } }
  end

  def test_valid_with_matching_values
    create_user = CreateUser.new(favourite_colors: ["green"])
    assert create_user.valid?
  end

  def test_valid_with_matching_proc_values
    create_user = CreateUserWithProc.new(favourite_colors: ["green"])
    assert create_user.valid?
  end

  def test_invalid_without_value
    create_user = CreateUser.new
    assert create_user.invalid?
  end

  def test_invalid_without_proc_value
    create_user = CreateUserWithProc.new
    assert create_user.invalid?
  end

  def test_valid_without_array
    create_user = CreateUser.new(favourite_colors: "green")
    assert create_user.valid?
  end

  def test_valid_without_proc_array
    create_user = CreateUserWithProc.new(favourite_colors: "green")
    assert create_user.valid?
  end

  def test_invalid_when_no_matching_value
    create_user = CreateUser.new(favourite_colors: ["black"])
    assert create_user.invalid?
  end

  def test_invalid_when_no_matching_proc_value
    create_user = CreateUserWithProc.new(favourite_colors: ["black"])
    assert create_user.invalid?
  end

  def test_error_details_when_invalid
    create_user = CreateUser.new(favourite_colors: ["black"])
    create_user.validate
    expected_error = {favourite_colors: [{error: :inclusion, value: ["black"]}]}
    assert_equal expected_error, create_user.errors.details
  end

  def test_error_details_when_proc_invalid
    create_user = CreateUserWithProc.new(favourite_colors: ["black"])
    create_user.validate
    expected_error = {favourite_colors: [{error: :inclusion, value: ["black"]}]}
    assert_equal expected_error, create_user.errors.details
  end

  def test_error_message_when_invalid
    create_user = CreateUser.new(favourite_colors: ["black"])
    create_user.validate
    expected_error = {favourite_colors: ["is not included in the list"]}
    assert_equal expected_error, create_user.errors.messages
  end

  def test_error_message_when_proc_invalid
    create_user = CreateUserWithProc.new(favourite_colors: ["black"])
    create_user.validate
    expected_error = {favourite_colors: ["is not included in the list"]}
    assert_equal expected_error, create_user.errors.messages
  end
end
