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

  def threaded(f: () => Unit) = {
    new Thread(new Runnable {
      def run = f()
    })
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
  val thread = threaded(func)
  println(thread)
}
