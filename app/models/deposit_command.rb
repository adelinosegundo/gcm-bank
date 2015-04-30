class DepositCommand
  attr_accessor :account_id, :amount

  def initialize account_id, amount
    self.account_id = account_id
    self.amount = amount
  end

  def valid?
    self.account_id != nil && self.amount != nil
  end

  def perform
    account = Account.find(self.account_id)
    account.balance += amount.to_f
    account.bonus += (amount.to_f)*0.03
    account.save!
  end
end
