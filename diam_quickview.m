function radius = diam_quickview(im,ROIs,r,ind)

radius = tcdetrend(r(2:end,ind));
mask = ROIs(:,:,ind);
im2 = im + mask*500;
subplot(121), show(im2),
subplot(122), plot(radius)
%x=im2;
end