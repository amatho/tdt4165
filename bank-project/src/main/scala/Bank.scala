class Bank(val allowedAttempts: Integer = 3) {

  private val transactionsQueue: TransactionQueue = new TransactionQueue()
  private val processedTransactions: TransactionQueue = new TransactionQueue()
  private var processingThread: Option[Thread] = None

  // Start a thread that calls `processTransactions`. Keep track of the thread
  // in the variable `processingThread` to make sure that only one processing
  // thread is running at the same time, and start a new one if the existing
  // thread is dead
  private def startProcessing: Unit = {
    // Inner method to create a new thread and store it in `processingThread`
    def createThread = {
      val t = new Thread(new Runnable {
        override def run = processTransactions
      })
      t.start
      processingThread = Some(t)
    }

    processingThread match {
      case Some(t) => {
        if (!t.isAlive) {
          createThread
        }
      }
      case None => {
        createThread
      }
    }
  }

  def addTransactionToQueue(from: Account, to: Account, amount: Double): Unit = {
    val transaction = new Transaction(transactionsQueue, processedTransactions, from, to, amount, allowedAttempts)
    transactionsQueue.push(transaction)

    // Starts the processing thread
    startProcessing
  }

  private def processTransactions: Unit = {
    val transaction = transactionsQueue.pop
    
    // Execute the transaction in a new thread
    val t = new Thread(transaction)
    t.start
    t.join

    // Put the transaction into the appropriate queue
    if (transaction.status == TransactionStatus.PENDING) {
      transactionsQueue.push(transaction)
    } else {
      processedTransactions.push(transaction)
    }

    // Recursively call this function as long as the transaction queue is not
    // empty
    if (!transactionsQueue.isEmpty) {
      processTransactions
    }
  }
                                              // TOO
                                              // project task 2
                                              // Function that pops a transaction from the queue
                                              // and spawns a thread to execute the transaction.
                                              // Finally do the appropriate thing, depending on whether
                                              // the transaction succeeded or not

  def addAccount(initialBalance: Double): Account = {
    new Account(this, initialBalance)
  }

  def getProcessedTransactionsAsList: List[Transaction] = {
    processedTransactions.iterator.toList
  }
}
