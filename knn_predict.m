function im = knn_predict(I,K,N) % I=input imread(image)
%I=imnoise(I,'salt & pepper',0.02);
%figure(1)
%imshow(I);
[m,n]=size(I);
s=ceil(N/2);
d=fix(N/2);
i_e=m-s+1;
j_e=n-s+1;
for i=s:i_e
      for j= s:j_e
        B=I(i-d:i+d,j-d:j+d);     
        A=reshape(B,1,[]);
        [val,id]=sort(abs(A-I(i,j)));
         for k=2:1+K
          t=k-1;
          C(t,1)= A(1,id(1,k)); 
         end
         I(i,j)=round(mean(C));
      end
end
im=I;
end
