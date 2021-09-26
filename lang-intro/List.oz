functor
export
    length: Length
    take: Take
    drop: Drop
    append: Append
    member: Member
    position: Position
    map: Map
    reverse: Reverse
define
    fun {Length List}
        case List of _ | Tail then
            1 + {Length Tail}
        [] nil then
            0
        end
    end

    fun {Take List Count}
        if Count > 0 then
            case List of Head | Tail then
                Head|{Take Tail Count-1}
            [] nil then
                nil
            end
        else
            nil
        end
    end

    fun {Drop List Count}
        if Count > 0 then
            case List of _ | Tail then
                {Drop Tail Count-1}
            [] nil then
                nil
            end
        else
            List
        end
    end

    fun {Append List1 List2}
        case List1 of Head | Tail then
            Head | {Append Tail List2}
        [] nil then
            List2
        end
    end

    fun {Member List Element}
        case List of Head | Tail then
            if Head == Element then
                true
            else
                {Member Tail Element}
            end
        [] nil then
            false
        end
    end

    fun {Position List Element}
        case List of Head | Tail then
            if Head == Element then
                0
            else
                1 + {Position Tail Element}
            end
        end
    end
    
    fun {Map List Function}
        case List of Head | Tail then
            {Function Head} | {Map Tail Function}
        else
            nil
        end
    end

    local
        fun {ReverseInner Xs Ys}
            case Xs of nil then
                Ys
            [] X | Xr then
                {ReverseInner Xr X | Ys}
            end
        end
    in
        fun {Reverse List}
            {ReverseInner List nil}
        end
    end
end
