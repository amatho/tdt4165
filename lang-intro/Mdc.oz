functor
import
    System
    List
define
    fun {Lex Input}
        {String.tokens Input & }
    end

    {System.showInfo "\na)"}
    {System.show {Lex "1 2 + 3 *"}}

    fun {Tokenize Lexemes}
        {List.map Lexemes fun {$ Lexeme}
            case Lexeme of "+" then
                operator(type:plus)
            [] "-" then
                operator(type:minus)
            [] "*" then
                operator(type:multiply)
            [] "/" then
                operator(type:divide)
            [] "p" then
                command(print)
            [] "d" then
                command(duplicate)
            [] "i" then
                command(flip)
            [] "^" then
                command(inverse)
            else
                number({String.toFloat Lexeme})
            end
        end}
    end


    {System.showInfo "\nb)"}
    Ls = {Lex "1 2 + 3 *"}
    Ts = {Tokenize Ls}
    {System.show Ts}

    local
        Operators = operators(
            plus: fun {$ A B} A + B end
            minus: fun {$ A B} A - B end
            multiply: fun {$ A B} A * B end
            divide: fun {$ A B} A / B end
        )

        Commands = commands(
            print: fun {$ Stack} {System.show {Tokenize {List.reverse Stack}}} Stack end
            duplicate: fun {$ Stack} Stack.1 | Stack end
            flip: fun {$ Stack} (~Stack.1) | Stack.2 end
            inverse: fun {$ Stack} (1.0 / Stack.1) | Stack.2 end
        )

        fun {Evaluate Tokens Stack}
            case Tokens of operator(type:Operator) | TokensTail then
                case Stack of OperandB | OperandA | StackTail then
                    {Evaluate TokensTail {Operators.Operator OperandA OperandB} | StackTail}
                else
                    raise "Invalid operation (expected two operands)" end
                end
            [] command(Command) | TokensTail then
                {Evaluate TokensTail {Commands.Command Stack}}
            [] number(Number) | TokensTail then
                {Evaluate TokensTail Number | Stack}
            [] nil then
                {Tokenize {List.reverse Stack}}
            else
                raise "Invalid expression (unexpected token)" end
            end
        end
    in
        fun {Interpret Tokens}
            {Evaluate Tokens nil}
        end
    end

    {System.showInfo "\nc)"}
    {System.show {Interpret {Tokenize {Lex "1 2 3 +"}}}}

    {System.showInfo "\nd)"}
    {System.show {Interpret {Tokenize {Lex "1 2 3 p +"}}}}

    {System.showInfo "\ne)"}
    {System.show {Interpret {Tokenize {Lex "1 2 3 + d"}}}}


    {System.showInfo "\nf)"}
    {System.show {Interpret {Tokenize {Lex "1 2 3 + i"}}}}

    
    {System.showInfo "\ng)"}
    {System.show {Interpret {Tokenize {Lex "1 2 3 + ^"}}}}

    local
        Operators = operators(
            plus: "+"
            minus: "-"
            multiply: "*"
            divide: "/"
        )

        Commands = commands(
            flip: "-"
            inverse: "1/"
        )

        fun {InfixInternal Tokens ExpressionStack}
            case Tokens of operator(type:Operator) | TokensTail then
                case ExpressionStack of OperandB | OperandA | StackTail then
                    {InfixInternal TokensTail "("#OperandA#" "#Operators.Operator#" "#OperandB#")" | StackTail}
                else
                    raise "Invalid operation (expected two operands)" end
                end
            [] command(Command) | TokensTail then
                case ExpressionStack of Operand | StackTail then
                    {InfixInternal TokensTail Commands.Command#Operand | StackTail}
                else
                    raise "Invalid command (missing operand)" end
                end
            [] number(Number) | TokensTail then
                {InfixInternal TokensTail Number | ExpressionStack}
            [] nil then
                ExpressionStack.1
            else
                raise "Invalid expression (unexpected token)" end
            end
        end
    in
        fun {Infix Tokens}
            {InfixInternal Tokens nil}
        end
    end

    {System.showInfo "\nTask 3 b)"}
    {System.showInfo {Infix {Tokenize {Lex "3.0 10.0 9.0 * - 0.3 +"}}}}
end
