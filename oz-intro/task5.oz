functor
import
    System
define
    proc {Circle R} A D C Pi in
        Pi = 355.0 / 113.0
        A = Pi * R * R
        D = 2.0 * R
        C = Pi * D
        
        {System.showInfo 'Circle with R = '#R#': A = '#A#', D = '#D#', C = '#C}
    end
    
    {Circle 3.0}
end
