require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Deposit" do
    acc = Account.create(balance: 0)
    command = DepositCommand.new(acc.id, 30)
    command.perform
    assert acc.balance, 30
  end

  test "Withdraw" do
    acc = Account.create(balance: 0)
    command = WithdrawCommand.new(acc.id, 30)
    command.perform
    assert acc.balance, -30
  end
end
