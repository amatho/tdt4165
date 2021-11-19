import exceptions._
import scala.collection.mutable
import scala.collection.JavaConverters._
import java.util.concurrent.ConcurrentLinkedQueue

object TransactionStatus extends Enumeration {
  val SUCCESS, PENDING, FAILED = Value
}

class TransactionQueue {

  private val queue = new ConcurrentLinkedQueue[Transaction]

  // Remove and return the first element from the queue
  def pop: Transaction = queue.poll

  // Return whether the queue is empty
  def isEmpty: Boolean = queue.isEmpty

  // Add new element to the back of the queue
  def push(t: Transaction): Unit = queue.add(t)

  // Return the first element from the queue without removing it
  def peek: Transaction = queue.peek

  // Return an iterator to allow you to iterate over the queue
  def iterator: Iterator[Transaction] = queue.iterator.asScala
}

class Transaction(val transactionsQueue: TransactionQueue,
                  val processedTransactions: TransactionQueue,
                  val from: Account,
                  val to: Account,
                  val amount: Double,
                  val allowedAttempts: Int) extends Runnable {

  var status: TransactionStatus.Value = TransactionStatus.PENDING
  var attempt = 0

  override def run: Unit = {
    def doTransaction() = {
      attempt += 1

      // Fail if the transaction has used too many attempts.
      // Set status to pending if either withdrawal or deposit fails.
      // Set status to sucess if both withdrawal and deposit succeeds
      if (attempt > allowedAttempts) {
        status = TransactionStatus.FAILED
      } else {
        from.withdraw(amount) match {
          case Left(()) => to.deposit(amount) match {
            case Left(()) => status = TransactionStatus.SUCCESS
            case Right(_) => status = TransactionStatus.PENDING
          }
          case Right(_) => status = TransactionStatus.PENDING
        }
      }
    }

    // Ensure that no other threads executes this transaction at the same time
    this.synchronized {
      if (status == TransactionStatus.PENDING) {
        doTransaction

        Thread.sleep(50)
      }
    }
  }
}
