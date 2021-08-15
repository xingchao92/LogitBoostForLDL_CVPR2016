function y=K_L_dist(P,Q)
[rows,cols]=size(P);
for i=1:rows
    dist(i)=0;
    for j=1:cols
        if(P(i,j)<=0||Q(i,j)<=0)
            dist(i)=dist(i);
        else
            dist(i)=dist(i)+P(i,j)*log(P(i,j)/Q(i,j));
        end
    end
end
total_dist=0;
for i=1:rows
    total_dist=total_dist+dist(i);
end
average_dist=total_dist/rows;
y=average_dist;
end
