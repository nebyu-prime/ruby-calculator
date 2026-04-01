require 'minitest/autorun'
require 'open3'

def run_expr(expr)
  Open3.capture3("ruby", "calculator.rb", expr)
end

class CalculatorTest < Minitest::Test
  def test_simple_add
    out, err, status = run_expr("2 + 3")
    assert_equal "5\n", out
    assert_equal 0, status.exitstatus
  end

  def test_precedence
    out, err, status = run_expr("2 + 3 * (4 - 1)")
    assert_equal "11\n", out
    assert_equal 0, status.exitstatus
  end

  def test_power
    out, err, status = run_expr("2 ^ 3")
    assert_equal "8\n", out
    assert_equal 0, status.exitstatus
  end

  def test_unsafe
    out, err, status = run_expr("system('ls')")
    assert_equal 1, status.exitstatus
    assert_match /Unsafe expression/, err
  end
end
