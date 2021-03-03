function [str_outline] = add_rectangle_to_svg(x, y, varargin)

% https://www.w3.org/TR/SVG11/shapes.html#RectElement

% parse optional style arguments
style = parse_styles(varargin{:});

% add definition
%rect = sprintf('x="%f" y="%f" width="%f" height="%f"', x(1)-1, y(1)-1, diff(x)+2, diff(y)+2);
rect = sprintf('x="%f" y="%f" width="%f" height="%f"', x(1), y(1), diff(x), diff(y));

% combine style and definition
str_outline = sprintf('<rect style="%s" %s/>', style.char, rect);

end
