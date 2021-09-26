functor
import
    System
define
    fun {Max Number1 Number2}
        if Number1 > Number2 then
            Number1
        else
            Number2
        end
    end

    {System.showInfo {Max 42 16}}

    proc {PrintGreater Number1 Number2}
        {System.showInfo {Max Number1 Number2}}
    end

    {PrintGreater 42 16}
end
