function [str_image] = add_image_to_svg(image, pos)

% https://www.w3.org/TR/SVG11/struct.html#ImageElement
% https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/SVG_Image_Tag
% https://stackoverflow.com/questions/6249664/does-svg-support-embedding-of-bitmap-images

% add image metadata
x = pos(1);
y = pos(2);
[height, width] = size(image, [1, 2]);
str_meta = sprintf('x="%f" y="%f" width="%f" height="%f"', x, y, width, height);

% embed the image
%TODO: what if we have a format other than png?
image_base64 = image2base64(image);
str_bits = sprintf('xlink:href="data:image/png;base64,%s"', image_base64);
% despite the ImageElement definition on w3.org, xlink:href is deprecated, just use href.
% [JC] xlink:href has been added to fix it for Inkscape and SVG viewers
% (gThumb)

% combine
str_image = sprintf('<image %s %s/>', str_meta, str_bits);

end
