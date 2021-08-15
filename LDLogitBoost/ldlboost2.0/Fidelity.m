function y=Fidelity(P,Q)
[rows,cols]=size(P);
for i=1:rows
    dist(i)=0;
    for j=1:cols
        dist(i)=dist(i)+sqrt(P(i,j)*abs(Q(i,j)));
    end
end
total_dist=0;
for i=1:rows
    total_dist=total_dist+dist(i);
end
average_dist=total_dist/rows;
y=average_dist;
end