using Images
using ImageMagick
using PyPlot
include("kMeans.jl")
 function quantize_image(I,k)
     #I=""
    pic=imread(I)
    (nRows,nCols,layer)=size(pic)
    m=nRows*nCols
    image=reshape(pic,m,layer)
   # w=zeros(k,layer)
    y=zeros(m)
    model=kMeans(image,k;doPlot=false)
    w= model.W
    y = model.predict(image)

    return [nRows,nCols,y,w]
end
I="dog.png"
b=6
k=2^b
model=quantize_image(I,k)
nRows=model[1]
nCols=model[2]
y=model[3]
w=model[4]

function deQuantizeImage(nRows,nCols,y,w)
    img=zeros(nRows*nCols,3)
    for i in 1:nRows*nCols
        for j in 1:3
        img[i,j]=w[y[i],j]
        end
    end
    q_img=reshape(img,nRows,nCols,3)
    return q_img
end
q_img=deQuantizeImage(nRows,nCols,y,w)
imshow(q_img)
