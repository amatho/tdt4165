functor
import
    System
define
    X = "This is a string"
    thread {System.showInfo Y} end
    Y = X
    %% It can print Y because the thread will wait until Y is assigned before running.
    %% This is useful since Oz will handle some of the difficulties with threading.
    %% The statement Y = X introduces the variable Y and assigns it the value of X.
end
