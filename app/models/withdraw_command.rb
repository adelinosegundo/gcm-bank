class WithdrawCommand
  attr_accessor :account_id, :amount

  def initialize account_id, amount
    self.account_id = account_id
    self.amount = amount
  end

  def valid?
    self.account_id != nil && self.amount != nil
  end

  def perform
    ##minimun 2 buck in account
    account = Account.find(self.account_id)
    account.balance -= amount.to_f
    account.save!
  end
end
