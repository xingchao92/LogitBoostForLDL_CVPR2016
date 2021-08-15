function y=sorensen_dist(P,Q)
[rows,cols]=size(P);
for i=1:rows
    dist(i)=0;
    A=0;
    B=0;
    for j=1:cols
        if (P(i,j)+Q(i,j)<0)
            A=A;
            B=B;
        else
            A=A+abs(P(i,j)-Q(i,j));
            B=B+(P(i,j)+Q(i,j));
        end
    end
    dist(i)=A/B;
end
total_dist=0;
for i=1:rows
    total_dist=total_dist+dist(i);
end
average_dist=total_dist/rows;
y=average_dist;
end