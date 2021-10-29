functor
import
    OS
    System
define

    fun {GenerateOdd S E}
        if S > E then
            nil
        elseif {Abs S} mod 2 == 0 then
            {GenerateOdd S + 1 E}
        else
            S | {GenerateOdd S + 1 E}
        end
    end

    fun {Product S}
        case S of Head | Tail then
            Head * {Product Tail}
        [] nil then
            1
        end
    end

    fun lazy {GenerateOddLazy S E}
        if S > E then
            nil
        elseif {Abs S} mod 2 == 0 then
            {GenerateOddLazy S + 1 E}
        else
            S | {GenerateOddLazy S + 1 E}
        end
    end

    fun {RandomInt Min Max}
        X = {OS.rand}
        MinOS
        MaxOS
    in
        {OS.randLimits ?MinOS ?MaxOS}
        Min + X*(Max - Min) div (MaxOS - MinOS)
    end

    fun lazy {HammerFactory}
        Hammer = if {RandomInt 0 100} =< 10 then
            defect
        else
            working
        end
    in
        {Delay 1000}
        Hammer | {HammerFactory}
    end

    fun {HammerConsumer HammerStream N}
        fun {Inner Stream TakeN Count}
            if TakeN =< 0 then
                Count
            else
                case Stream of working | Tail then
                    {Inner Tail TakeN - 1 Count + 1}
                [] Head | Tail then
                    {Inner Tail TakeN - 1 Count}
                end
            end
        end
    in
        {Inner HammerStream N 0}
    end

    fun {BoundedBuffer HammerStream N}
        % Lazy function to prevent recursing through the stream eagerly
        fun lazy {Inner Stream ReducedStream}
            % Get the next item of the stream (which might have been pre-evaluated)
            case Stream of Head | Tail then
                % Return the next item of the stream and append a recursive call to Inner
                % to get the tail, while also pre-evaluating the next item in the stream
                Head | {Inner Tail thread ReducedStream.2 end}
            end
        end
    in
        % Call Inner and pre-evaluate the first N items of the stream
        {Inner HammerStream thread {List.drop HammerStream N} end}
    end

    {System.showInfo 'Task 1:'}
    {System.show {GenerateOdd ~3 10}}
    {System.show {GenerateOdd 3 3}}
    {System.show {GenerateOdd 2 2}}
    
    {System.showInfo '\nTask 2:'}
    {System.show {Product [1 2 3 4]}}

    {System.showInfo '\nTask 3:'}
    local Numbers ProductResult in
        thread Numbers = {GenerateOdd 0 1000} end
        thread ProductResult = {Product Numbers} end
        {System.showInfo ProductResult}
    end

    {System.showInfo '\nTask 4:'}
    local Numbers ProductResult in
        thread Numbers = {GenerateOddLazy 0 1000} end
        thread ProductResult = {Product Numbers} end
        {System.showInfo ProductResult}
    end

    {System.showInfo '\nTask 5 a):'}
    local HammerTime in
        HammerTime = {HammerFactory}
        _ = HammerTime.2.2.2.1
        {System.show HammerTime}
    end

    {System.showInfo '\nTask 5 b):'}
    local HammerTime Consumer in
        HammerTime = {HammerFactory}
        Consumer = {HammerConsumer HammerTime 10}
        {System.show Consumer}
    end

    {System.showInfo '\nTask 5 c) with buffer:'}
    local HammerStream Buffer Consumer in
        HammerStream = {HammerFactory}
        Buffer = {BoundedBuffer HammerStream 6}
        {Delay 6000}
        Consumer = {HammerConsumer Buffer 10}
        {System.show Consumer}
    end

    {System.showInfo '\nTask 5 c) without buffer:'}
    local HammerStream Consumer in
        HammerStream = {HammerFactory}
        {Delay 6000}
        Consumer = {HammerConsumer HammerStream 10}
        {System.show Consumer}
    end
end
