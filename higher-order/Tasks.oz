declare QuadraticEquation in
proc {QuadraticEquation  A B C ?RealSol ?X1 ?X2} Discriminant in
    Discriminant = {Number.pow B 2.0} - 4.0 * A * C
    RealSol = Discriminant >= 0.0

    if RealSol then
        X1 = ~B + {Float.sqrt Discriminant} / 2.0 * A
        X2 = ~B - {Float.sqrt Discriminant} / 2.0 * A
    end
end

declare Sum in
fun {Sum List}
    case List of Head | Tail then
        Head + {Sum Tail}
    [] nil then
        0
    end
end

declare RightFold in
fun {RightFold List Op U}
    case List of Head | Tail then
        {Op Head {RightFold Tail Op U}}
    [] nil then
        U
    end
end

declare Length in
fun {Length List}
    {RightFold List fun {$ Curr Acc} 1 + Acc end 0}
end

declare SumFold in
fun {SumFold List}
    {RightFold List fun {$ Curr Acc} Curr + Acc end 0}
end

declare Quadratic in
fun {Quadratic A B C}
    fun {$ X} A * X * X + B * X + C end
end

declare LazyNumberGenerator in
fun {LazyNumberGenerator StartValue} Lazy in
    Lazy = fun {$} {LazyNumberGenerator StartValue + 1} end

    num(StartValue Lazy)
end

declare SumTailRecursive in
fun {SumTailRecursive List}
    fun {Inner List Acc}
        case List of Head | Tail then
            {Inner Tail Acc + Head}
        [] nil then
            Acc
        end
    end
in
    {Inner List 0}
end

functor
import
    System
define
    {System.showInfo 'Task 1:'}
    local RealSol X1 X2 in
        {QuadraticEquation 2.0 1.0 ~1.0 RealSol X1 X2}
        {System.show 'X1 = '#X1#' X2 = '#X2#'Real = '#RealSol}
    end
    local RealSol X1 X2 in
        {QuadraticEquation 2.0 1.0 2.0 RealSol X1 X2}
        {System.show 'X1 = '#X1#' X2 = '#X2#'Real = '#RealSol}
    end

    {System.showInfo '\nTask 2:'}
    {System.showInfo 'Sum = '#{Sum [1 2 3 4 5 6]}}

    {System.showInfo '\nTask 3:'}
    {System.showInfo 'Length = '#{Length [1 2 3 4 5 6]}}
    {System.showInfo 'Sum = '#{SumFold [1 2 3 4 5 6]}}

    {System.showInfo '\nTask 4:'}
    {System.showInfo 'f(x) = '#{{Quadratic 3 2 1} 2}}

    {System.showInfo '\nTask 5:'}
    {System.show {LazyNumberGenerator 0}.1}
    {System.show {{LazyNumberGenerator 0}.2}.1}
    {System.show {{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1}

    {System.showInfo '\nTask 6:'}
    {System.showInfo 'Sum = '#{SumTailRecursive [1 2 3 4 5 6]}}
end
