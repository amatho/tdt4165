object Main extends App {
  def sumLoop(a: Array[Int]): Int = {
    var res = 0
    for (i <- 0 until a.length) res += a(i)
    res
  }

  def sumRecursion(a: Array[Int]): Int = {
    if (a.length == 1) {
      a.head
    } else {
      a.head + sumRecursion(a.slice(1, a.length))
    }
  }

  def fibonacci(n: BigInt): BigInt = {
    if (n == 0)
      0
    else if (n == 1)
      1
    else
      fibonacci(n - 1) + fibonacci(n - 2)
  }

  def waitingThread(f: () => Unit) = {
    new Thread {
      override def run = {
        f()
      }
    }
  }

  def thread(f: => Unit) = {
    val t = new Thread {
      override def run = f
    }
    t.start
    t
  }

  val arr = new Array[Int](51)
  for (i <- 0 to 50) arr(i) = i

  val sl = sumLoop(arr)
  println(s"Sum using for loop: $sl")
  val sr = sumRecursion(arr)
  println(s"The sum is $sr")

  val fib = fibonacci(12)
  println(s"fibonacci(12) = $fib")

  val func = () => println("A function")
  val funcThread = waitingThread(func)
  println(funcThread)

  private var counter: Int = 0
  def increaseCounter(): Unit = this.synchronized {
    counter += 1
  }

  def printCounter(): Unit = this.synchronized {
    println(counter)
  }

  val inc1 = thread { increaseCounter() }
  val inc2 = thread { increaseCounter() }
  val printer = thread { printCounter() }

  printer.join
  inc1.join
  inc2.join

  object Deadlock {
    lazy val foo = 42
    lazy val bar = (1 to 1).par.map(i => Deadlock.foo + i)
  }

  // Uncomment the line below to cause a deadlock
  // Deadlock.bar
}
