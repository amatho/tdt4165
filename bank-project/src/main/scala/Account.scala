import exceptions._

class Account(val bank: Bank, initialBalance: Double) {

  class Balance(var amount: Double) {}

  val balance = new Balance(initialBalance)

  def withdraw(amount: Double): Either[Unit, String] = {
    // Check if the amount is negative, or if the account has insufficient
    // balance. The whole if-elseif-else expression is synchronized, since all
    // accesses of `balance.amount` must be synchronized
    this.synchronized {
      if (amount < 0) {
        Right("Cannot withdraw a negative amount")
      } else if (amount > balance.amount) {
        Right("Withdrawal amount is higher than available balance")
      } else {
          balance.amount -= amount
        Left(())
      }
    }
  }

  def deposit(amount: Double): Either[Unit, String] = {
    // Check if the amount is negative, otherwise do a synchronized deposit
    if (amount < 0) {
      Right("Cannot deposit a negative amount")
    } else {
      this.synchronized {
        balance.amount += amount
      }
      Left(())
    }
  }

  // Access the account balance with synchronization
  def getBalanceAmount: Double = this.synchronized { balance.amount }

  def transferTo(account: Account, amount: Double) = {
    bank addTransactionToQueue (this, account, amount)
  }
}
