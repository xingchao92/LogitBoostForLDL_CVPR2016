function y=Euc_L2_dist(P,Q)
[rows,cols]=size(P);
for i=1:rows
    dist(i)=0;
    for j=1:cols
        dist(i)=dist(i)+abs(P(i,j)-Q(i,j))^2;
    end
    dist(i)=sqrt(dist(i));
end
total_dist=0;
for i=1:rows
    total_dist=total_dist+dist(i);
end
average_dist=total_dist/rows;
y=average_dist;
end