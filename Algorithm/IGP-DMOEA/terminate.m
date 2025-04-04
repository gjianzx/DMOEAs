function y =terminate(itrcounter)
    global params;
    y = itrcounter>params.iteration;
end